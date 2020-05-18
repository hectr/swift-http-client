import Foundation

public struct StringSerializer: BodySerializer, Codable, Equatable {
    private let codableString: CodableString

    public init(_ codableString: CodableString) {
        self.codableString = codableString
    }

    public func contentHeaders() -> Headers {
        let charset = codableString
            .encoding
            .description
            .components(separatedBy: "Unicode (")
            .last?
            .components(separatedBy: ")")
            .first
            ?? ""
        if charset.hasPrefix("UTF-") {
            return [("Content-Type", "text/plain; charset=\(charset)")]
        } else {
            return [("Content-Type", "text/plain")]
        }
    }

    public func contentData() throws -> Data {
        try codableString.toData()
    }

    public func toCurlBody() -> [String] {
        ["--data-binary \"\(codableString.string.toEscapedString())\""]
    }
}

// MARK: - ExpressibleByStringLiteral

extension StringSerializer: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self.init(CodableString(stringLiteral: value))
    }
}
