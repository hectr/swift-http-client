import Foundation

public struct DataSerializer: BodySerializer, Codable, Equatable {
    private let data: Data

    public init(_ data: Data) {
        self.data = data
    }

    public func contentHeaders() -> Headers {
        [("Content-Type", "application/octet-stream")]
    }

    public func contentData() throws -> Data {
        data
    }

    public func toCurlBody() -> [String] {
        if let string = String(data: data, encoding: .utf8) {
            return ["--data-binary \"\(string.toEscapedString())\""]
        } else {
            return ["--data-binary @filename"]
        }
    }
}
