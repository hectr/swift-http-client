import Foundation

public struct DataDeserializer: Codable, Deserializer, Equatable {
    public init() {}

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        guard let value = data as? T else {
            assertionFailure("type mismatch: expected \(Data.self), found \(T.self)")
            throw Error.typeMismatch(expected: Data.self, found: T.self)
        }
        return value
    }
}
