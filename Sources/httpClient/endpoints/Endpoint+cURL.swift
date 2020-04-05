import Foundation
import Idioms

extension Endpoint {
    public func cURL(replaceNewLinesInRawBodyWithSpaces: Bool = false,
                     replaceTabsInRawBodyWithSpaces: Bool = false,
                     bodyEncoding: String.Encoding = .utf8) -> String {
        var command = Self.cURL(endpoint: self,
                                bodyEncoding: bodyEncoding)
        if replaceTabsInRawBodyWithSpaces {
            command = command.replacingOccurrences(of: "\t", with: "    ")
        }
        if replaceNewLinesInRawBodyWithSpaces {
            command = command.replacingOccurrences(of: "\n", with: " ")
        }
        return command
    }

    private static func cURL(endpoint: Endpoint,
                             bodyEncoding: String.Encoding) -> String {
        var lines = [String]()
        lines.append("-X \(endpoint.method.rawValue)")
        lines.append(contentsOf: buildHeaders(for: endpoint))
        lines.append(contentsOf: buildBody(for: endpoint, encoding: bodyEncoding))
        if let url = try? URL.build(with: endpoint) {
            lines.append(contentsOf: buildCookies(for: url))
            lines.append("\"\(url.absoluteString)\"")
        }
        return lines
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.prepending("  ") }
            .prepending("curl")
            .joined(separator: " \\\n")
    }

    private static func buildHeaders(for endpoint: Endpoint) -> [String] {
        endpoint
            .httpHeaderFields
            .reduce(into: [String]()) { lines, field in
                let name = field.key
                let value = field.value.replacingOccurrences(of: "\'", with: "\\\'")
                let header = "'\(name): \(value)'"
                lines.append("-H \(header)")
                if field.key.lowercased() == "accept-encoding",
                    value.lowercased().contains(word: "gzip") {
                    lines.append("--compressed")
                }
            }
    }

    private static func escapedBody(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "$", with: "\\$")
    }

    private static func buildFormParameter(from multipartParameter: MultipartParameter) -> String {
        var components = [String]()
        if !multipartParameter.name.isEmpty {
            components.append("name=\(multipartParameter.name)")
        }
        if !multipartParameter.fileName.isEmpty {
            components.append("filename=\(multipartParameter.fileName)")
        }
        components.append("data=@filename")
        if !multipartParameter.mimeType.isEmpty {
            components.append("type=\(multipartParameter.mimeType)")
        }
        return "--form \(components.joined(separator: ";"))"
    }

    private static func buildBody(for endpoint: Endpoint, encoding: String.Encoding) -> [String] {
        switch endpoint.body {
        case .empty:
            return []

        case let .string(codableString):
            return ["--data-binary \"\(escapedBody(codableString.string))\""]

        case let .data(data):
            if let string = String(data: data, encoding: encoding) {
                return ["--data-binary \"\(escapedBody(string))\""]
            } else {
                return ["--data-binary @filename"]
            }

        case let .json(bodyParameters):
            if let string = try? bodyParameters.toJSONString() {
                return ["--data-binary \"\(escapedBody(string))\""]
            } else {
                return ["--data-binary @filename"]
            }

        case let .formUrlEncoded(parameters):
            if let string = parameters.toURLComponents().percentEncodedQuery {
                return ["--data-urlencode \"\(escapedBody(string))\""]
            } else {
                return parameters.map { "-d \"\($0.key)=\($0.value)\"" }
            }

        case let .multipartformData(multipartParameters):
            return multipartParameters.map { buildFormParameter(from: $0) }
        }
    }

    private static func buildCookies(for url: URL) -> [String] {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            return cookies.map { "--cookie \"\($0.name)=\($0.value)\"" }
        } else {
            return []
        }
    }
}
