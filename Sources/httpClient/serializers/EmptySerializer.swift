import Foundation

public struct EmptySerializer: BodySerializer, Codable, Equatable {
    public init() {}

    public func contentHeaders() -> Headers {
        [("Content-Length", "0")]
    }

    public func contentData() throws -> Data {
        Data()
    }

    public func toCurlBody() -> [String] {
        []
    }
}
