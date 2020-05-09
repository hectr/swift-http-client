import Foundation
import Idioms

extension Endpoint {
    public func cURL(verbose: Bool = true,
                     fallbackBodyEncoding: String.Encoding = .utf8) -> String {
        var lines = [String]()
        lines.append("--request \(method.rawValue)")
        lines.append(contentsOf: buildHeaders())
        lines.append(contentsOf: buildBody(fallbackEncoding: fallbackBodyEncoding))
        if let url = try? URL.build(with: self) {
            lines.append(contentsOf: buildCookies(for: url))
            lines.append("\"\(url.absoluteString)\"")
        }
        return lines
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.prepending("  ") }
            .prepending(verbose ? "curl --verbose" : "curl")
            .joined(separator: " \\\n")
    }

    private func buildHeaders() -> [String] {
        headers
            .reduce(into: [String]()) { lines, field in
                let name = field.key
                let value = field.value.replacingOccurrences(of: "\'", with: "\\\'")
                let header = "'\(name): \(value)'"
                lines.append("--header \(header)")
                if field.key.lowercased() == "accept-encoding",
                    value.lowercased().contains(word: "gzip") {
                    lines.append("--compressed")
                }
            }
    }

    private func escapedBody(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "$", with: "\\$")
    }

    private func buildFormParameter(from multipartParameter: MultipartParameter) -> String {
        var components = [String]()
        if !multipartParameter.name.isEmpty {
            components.append("name=\(multipartParameter.name)")
        }
        if let filename = multipartParameter.filename, !filename.isEmpty {
            components.append("filename=\(filename)")
        }
        components.append("data=@filename")
        if let mimeType = multipartParameter.mimeType, !mimeType.isEmpty {
            components.append("type=\(mimeType)")
        }
        return "--form '\(components.joined(separator: ";"))'"
    }

    private func buildBody(fallbackEncoding: String.Encoding) -> [String] {
        switch body {
        case .empty:
            return []

        case let .string(codableString):
            return ["--data-binary \"\(escapedBody(codableString.string))\""]

        case let .data(data):
            if let string = String(data: data, encoding: fallbackEncoding) {
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

        case let .multipartFormData(multipartParameters):
            return multipartParameters.map { buildFormParameter(from: $0) }
        }
    }

    private func buildCookies(for url: URL) -> [String] {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            return cookies.map { "--cookie \"\($0.name)=\($0.value)\"" }
        } else {
            return [] 
        }
    }
}
