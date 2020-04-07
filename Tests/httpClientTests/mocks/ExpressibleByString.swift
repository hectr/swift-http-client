import Foundation

public protocol ExpressibleByString {
    init?(stringRepresentation candidate: String)
}

extension ExpressibleByString where Self: LosslessStringConvertible {
    public init?(stringRepresentation candidate: String) {
        self.init(candidate)
    }
}

extension ExpressibleByString where Self: RawRepresentable, Self.RawValue: LosslessStringConvertible {
    public init?(stringRepresentation candidate: String) {
        guard let rawValue = RawValue(candidate) else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
}

// MARK: - Optional conformance

extension Optional: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral where Wrapped: ExpressibleByString {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = Wrapped(stringRepresentation: value) ?? .none
    }
}
