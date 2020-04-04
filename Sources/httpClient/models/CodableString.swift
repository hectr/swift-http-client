import Foundation

public struct CodableString: Codable, Equatable {
    let string: String
    let encoding: String.Encoding
}

// MARK: - ExpressibleByStringLiteral

extension CodableString: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = .init(string: value, encoding: .utf8)
    }
}
