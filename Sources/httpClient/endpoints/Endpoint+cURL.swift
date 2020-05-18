import Foundation
import Idioms

extension Endpoint {
    public func toCurl(verbose: Bool = true) -> String {
        var lines = [String]()
        lines.append("--request \(method.verb)")
        lines.append(contentsOf: buildHeaders())
        lines.append(contentsOf: body.toCurlBody())
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

    private func buildCookies(for url: URL) -> [String] {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            return cookies.map { "--cookie \"\($0.name)=\($0.value)\"" }
        } else {
            return []
        }
    }
}
