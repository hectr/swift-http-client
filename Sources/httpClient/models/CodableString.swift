import Foundation

public struct CodableString: Codable, Equatable {
    public let string: String
    public let encoding: String.Encoding

    public init(string: String, encoding: String.Encoding) {
        self.string = string
        self.encoding = encoding
    }

    public func toData() throws -> Data {
        guard let data = string.data(using: encoding) else {
            throw Error.stringNotSerializable(string, encoding)
        }
        return data
    }
}

// MARK: - ExpressibleByStringLiteral

extension CodableString: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = .init(string: value, encoding: .utf8)
    }
}
