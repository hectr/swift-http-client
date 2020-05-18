import Foundation

public struct CodableString: Codable, Equatable {
    public let string: String
    public let encoding: String.Encoding

    public init(string: String, encoding: String.Encoding) {
        self.string = string
        self.encoding = encoding
    }

    public func toData() throws -> Data {
        try string.toData(encoding: encoding)
    }
}

// MARK: - ExpressibleByStringLiteral

extension CodableString: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value, encoding: .utf8)
    }
}
