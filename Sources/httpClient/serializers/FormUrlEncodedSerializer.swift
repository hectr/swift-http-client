import Foundation

public struct FormUrlEncodedSerializer: BodySerializer, Codable, Equatable {
    private let parameters: Parameters

    public init(_ parameters: Parameters) {
        self.parameters = parameters
    }

    public func contentHeaders() -> Headers {
        [("Content-Type", "application/x-www-form-urlencoded")]
    }

    public func contentData() throws -> Data {
        try parameters
            .toURLComponents()
            .percentEncodedQuery?
            .toData()
            ?? Data()
    }

    public func toCurlBody() -> [String] {
        if let string = parameters.toURLComponents().percentEncodedQuery {
            return ["--data-urlencode \"\(string.toEscapedString())\""]
        } else {
            return parameters.map { "-d \"\($0.key)=\($0.value)\"" }
        }
    }
}
