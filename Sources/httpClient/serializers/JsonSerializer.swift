import Foundation

public struct JsonSerializer: BodySerializer, Codable, Equatable {
    private let parameters: BodyParameters

    public init(_ parameters: BodyParameters) {
        self.parameters = parameters
    }

    public func contentHeaders() -> Headers {
        [("Content-Type", "application/json; charset=UTF-8")]
    }

    public func contentData() throws -> Data {
        try parameters.toJSONData()
    }

    public func toCurlBody() -> [String] {
        if let string = try? parameters.toJSONString() {
            return ["--data-binary \"\(string.toEscapedString())\""]
        } else {
            return ["--data-binary @filename"]
        }
    }
}

// MARK: - ExpressibleByArray

extension JsonSerializer: ExpressibleByArray {
    public typealias ArrayLiteralElement = BodyParameter

    public init(elements: [ArrayLiteralElement]) {
        self.init(BodyParameters(elements))
    }
}

// MARK: - ExpressibleByDictionary

extension JsonSerializer: ExpressibleByDictionary {
    public typealias Key = String
    public typealias Value = BodyParameter

    public init(dictionaryElements: [(String, BodyParameter)]) {
        let bodyParameter = dictionaryElements.reduce(into: [String: BodyParameter]()) { $0[$1.0] = $1.1 }
        self.init(BodyParameters(bodyParameter))
    }
}
