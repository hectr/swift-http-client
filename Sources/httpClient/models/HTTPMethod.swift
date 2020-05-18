import Foundation

public enum HTTPMethod {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
    case custom(String)

    public var verb: String {
        switch self {
        case .connect:
            return "CONNECT"

        case .delete:
            return "DELETE"

        case .get:
            return "GET"

        case .head:
            return "HEAD"

        case .options:
            return "OPTIONS"

        case .patch:
            return "PATCH"

        case .post:
            return "POST"

        case .put:
            return "PUT"

        case .trace:
            return "TRACE"

        case let .custom(verb):
            return verb
        }
    }

    public init(verb: String) {
        self = .custom(verb)
    }
}

// MARK: - Codable

extension HTTPMethod: Codable {
    public init(from decoder: Decoder) throws {
        let decodedString = try String(from: decoder)
        self.init(stringLiteral: decodedString)
    }

    public func encode(to encoder: Encoder) throws {
        try verb.encode(to: encoder)
    }
}

// MARK: - CustomStringConvertible

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        verb
    }
}

// MARK: - Equatable

extension HTTPMethod: Equatable {
    public static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        lhs.verb == rhs.verb
    }
}

// MARK: - ExpressibleByStringLiteral

extension HTTPMethod: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self.init(verb: value)
    }
}

// MARK: - LosslessStringConvertible

extension HTTPMethod: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(verb: description)
    }
}
