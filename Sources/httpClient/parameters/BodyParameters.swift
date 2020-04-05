import Foundation

public struct BodyParameters: Equatable {
    public typealias ArrayLiteralElement = BodyParameter
    public typealias Key = String
    public typealias Value = BodyParameter

    private let bodyParameter: BodyParameter

    public init(_ bodyParameter: BodyParameter) {
        self.bodyParameter = bodyParameter
    }

    public func toJSONData(options: JSONSerialization.WritingOptions = [.fragmentsAllowed]) throws -> Data {
        try bodyParameter.toJSONData(options: options)
    }

    public func toJSONString(options: JSONSerialization.WritingOptions = [.fragmentsAllowed]) throws -> String {
        let data = try toJSONData(options: options)
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.stringNotDeserializable(data, .utf8)
        }
        return string
    }
}

// MARK: - Codable

extension BodyParameters: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let data = try container.decode(Data.self)
        bodyParameter = try data.toBodyParameter()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(bodyParameter.toJSONData())
    }
}

// MARK: - Equatable

extension BodyParameters {
    public static func == (lhs: BodyParameters, rhs: BodyParameters) -> Bool {
        (try? lhs.bodyParameter.toJSONData() == rhs.bodyParameter.toJSONData()) ?? false
    }
}

// MARK: - ExpressibleByArrayLiteral

extension BodyParameters: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: BodyParameter...) {
        self = BodyParameters(elements)
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension BodyParameters: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, BodyParameter)...) {
        let bodyParameter = elements.reduce(into: [String: BodyParameter]()) { $0[$1.0] = $1.1 }
        self = BodyParameters(bodyParameter)
    }
}

// MARK: - ExpressibleByStringLiteral

extension BodyParameters: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = BodyParameters(value)
    }
}
