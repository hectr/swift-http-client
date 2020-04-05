import Foundation

public enum HTTPMethod: String, CaseIterable, Codable, Equatable {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
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

