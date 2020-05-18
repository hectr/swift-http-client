import Foundation

public struct AnyBodySerializer: BodySerializer {
    private let _headers: () -> Headers
    private let _content: () throws -> Data
    private let _curlBody: () -> [String]

    public init<Serializer: BodySerializer>(_ serializer: Serializer) {
        _headers = serializer.contentHeaders
        _content = serializer.contentData
        _curlBody = serializer.toCurlBody
    }

    public init(headers: Headers,
                content: Data,
                curlBody: [String]) {
        _headers = { headers }
        _content = { content }
        _curlBody = { curlBody }
    }

    public func contentHeaders() -> Headers {
        _headers()
    }

    public func contentData() throws -> Data {
        try _content()
    }

    public func toCurlBody() -> [String] {
        _curlBody()
    }
}

// MARK: - Codable

extension AnyBodySerializer: Codable {
    enum CodingKeys: CodingKey {
        case headers
        case content
        case curlBody
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(headers: try container.decode(Headers.self, forKey: .headers),
                  content: try container.decode(Data.self, forKey: .content),
                  curlBody: try container.decode([String].self, forKey: .curlBody))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentHeaders(), forKey: .headers)
        try container.encode(contentData(), forKey: .content)
        try container.encode(toCurlBody(), forKey: .curlBody)
    }
}

// MARK: - Equatable

extension AnyBodySerializer: Equatable {
    public static func == (lhs: AnyBodySerializer, rhs: AnyBodySerializer) -> Bool {
        do {
            return try lhs.contentHeaders() == rhs.contentHeaders()
                && lhs.contentData() == rhs.contentData()
                && lhs.toCurlBody() == rhs.toCurlBody()
        } catch {
            return false
        }
    }
}

// MARK: - ExpressibleByArray

extension AnyBodySerializer: ExpressibleByArray {
    public typealias ArrayLiteralElement = BodyParameter

    public init(elements: [ArrayLiteralElement]) {
        self.init(JsonSerializer(arrayLiteral: elements))
    }
}

// MARK: - ExpressibleByDictionary

extension AnyBodySerializer: ExpressibleByDictionary {
    public typealias Key = String
    public typealias Value = BodyParameter

    public init(dictionaryElements: [(Key, Value)]) {
        let bodyParameter = dictionaryElements.reduce(into: [String: BodyParameter]()) { $0[$1.0] = $1.1 }
        self.init(JsonSerializer(BodyParameters(bodyParameter)))
    }
}

// MARK: - ExpressibleByStringLiteral

extension AnyBodySerializer: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self.init(StringSerializer(CodableString(stringLiteral: value)))
    }
}
