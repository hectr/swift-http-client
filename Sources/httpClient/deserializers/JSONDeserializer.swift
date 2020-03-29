import Foundation

public struct JSONDeserializer: Deserializer {
    private let decoder = JSONDecoder()

    public init() {}

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        let value = try decoder.decode(T.self, from: data)
        return value
    }
}

// MARK: - Codable

extension JSONDeserializer: Codable {
    public init(from _: Decoder) throws {
        self.init()
    }

    public func encode(to _: Encoder) throws {}
}

// MARK: - Equatable

extension JSONDeserializer: Equatable {
    public static func == (_: JSONDeserializer, _: JSONDeserializer) -> Bool {
        true
    }
}
