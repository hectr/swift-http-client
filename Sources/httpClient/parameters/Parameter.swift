import Foundation

public struct Parameter: Equatable {
    public typealias Key = String
    public typealias Value = String

    public let key: Key
    public let value: Value

    public init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }

    public func toURLQueryItem() -> URLQueryItem {
        URLQueryItem(name: key, value: value)
    }
}

// MARK: - Codable

extension Parameter: Codable {
    public init(from decoder: Decoder) throws {
        let decodedString = try String(from: decoder)
        let queryItem = try decodedString.toURLQueryItem()
        self = queryItem.toParameter()
    }

    public func encode(to encoder: Encoder) throws {
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: key, value: value)]
        try components.percentEncodedQuery.encode(to: encoder)
    }
}
