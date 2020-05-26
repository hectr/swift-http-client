import Foundation

extension Data {
    func toCurlBody() throws -> [String] {
        guard let string = String(data: self, encoding: .utf8) else {
            throw Error.stringNotDeserializable(self, .utf8)
        }
        return ["--data-binary \"\(string.toEscapedString())\""]
    }
}
