import Foundation

public enum HTTPMethod: String, CaseIterable, Codable, Equatable {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

// MARK: - CustomStringConvertible

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

// MARK: - ExpressibleByString

extension HTTPMethod: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        self.init(candidate)
    }
}

// MARK: - LosslessStringConvertible

extension HTTPMethod: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(rawValue: description.uppercased())
    }
}

