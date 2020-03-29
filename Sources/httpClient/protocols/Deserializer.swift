import Foundation

public protocol Deserializer {
    func deserialize<T: Decodable>(data: Data) throws -> T
}
