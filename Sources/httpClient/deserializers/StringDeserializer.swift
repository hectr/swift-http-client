import Foundation

public struct StringDeserializer: Codable, Deserializer, Equatable {
    private let encoding: String.Encoding

    public init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        guard let string = String(data: data, encoding: encoding) else {
            throw Error.stringNotDeserializable(data, encoding)
        }
        guard let response = string as? T else {
            assertionFailure("type mismatch: expected \(String.self), found \(T.self)")
            throw Error.typeMismatch(expected: String.self, found: T.self)
        }
        return response
    }
}
