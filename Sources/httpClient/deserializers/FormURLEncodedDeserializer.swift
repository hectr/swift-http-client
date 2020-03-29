import Foundation

public struct FormURLEncodedDeserializer: Codable, Deserializer, Equatable {
    private let stringDeserializer: StringDeserializer

    public init(stringDeserializer: StringDeserializer = StringDeserializer()) {
        self.stringDeserializer = stringDeserializer
    }

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        if let result = data as? T {
            return result
        }
        let string: String = try stringDeserializer.deserialize(data: data)
        if let result = string as? T {
            return result
        }
        let queryItems = try string.toURLQueryItems()
        let parameterArray = queryItems.map { $0.toParameter() }
        if let result = parameterArray as? T {
            return result
        }
        let parameters = Parameters(parameterArray)
        if let result = parameters as? T {
            return result
        }
        let dictionary = parameters.reduce(into: [String: String]()) { $0[$1.key] = $1.value }
        if let result = dictionary as? T {
            return result
        }
        let elements = parameters.map { ($0.key, $0.value) } as? T
        if let result = elements {
            return result
        }
        let dictionaries = parameters.map { [$0.key: $0.value] } as? T
        if let result = dictionaries {
            return result
        }
        assertionFailure("type mismatch: expected \(Parameters.self), found \(T.self)")
        throw Error.typeMismatch(expected: Parameters.self, found: T.self)
    }
}
