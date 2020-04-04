import Foundation

public enum RequestBody {
    case empty
    case string(CodableString)
    case data(Data)
    case json(BodyParameters)
    case formUrlEncoded(Parameters)
    case multipartformData(MultipartParameters)
}

// MARK: - Codable

extension RequestBody: Codable {
    enum CodingKeys: String, CodingKey {
        case string
        case data
        case json
        case parameters
        case multipartParameters
    }

    private var associatedValues: (CodableString?, Data?, BodyParameters?, Parameters?, MultipartParameters?) {
        switch self {
        case .empty:
            return (nil, nil, nil, nil, nil)

        case let .string(encodableString):
            return (encodableString, nil, nil, nil, nil)

        case let .data(data):
            return (nil, data, nil, nil, nil)

        case let .json(bodyParameters):
            return (nil, nil, bodyParameters, nil, nil)

        case let .formUrlEncoded(parameters):
            return (nil, nil, nil, parameters, nil)

        case let .multipartformData(multipartParameters):
            return (nil, nil, nil, nil, multipartParameters)
        }
    }

    // MARK: Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(MultipartParameters.self, forKey: .multipartParameters) {
            self = .multipartformData(value)

        } else if let value = try container.decodeIfPresent(Parameters.self, forKey: .parameters) {
            self = .formUrlEncoded(value)

        } else if let value = try container.decodeIfPresent(BodyParameters.self, forKey: .json) {
            self = .json(value)

        } else if let value = try container.decodeIfPresent(Data.self, forKey: .data) {
            self = .data(value)

        } else if let value = try container.decodeIfPresent(CodableString.self, forKey: .string) {
            self = .string(value)

        } else {
            self = .empty
        }
    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .empty:
            break

        case let .string(encodableString):
            try container.encode(encodableString, forKey: .string)

        case let .data(data):
            try container.encode(data, forKey: .data)

        case let .json(bodyParameters):
            try container.encode(bodyParameters, forKey: .json)

        case let .formUrlEncoded(parameters):
            try container.encode(parameters, forKey: .parameters)

        case let .multipartformData(multipartParameters):
            try container.encode(multipartParameters, forKey: .multipartParameters)
        }
    }
}

// MARK: - Equatable

extension RequestBody: Equatable {
    public static func == (lhs: RequestBody, rhs: RequestBody) -> Bool {
        lhs.associatedValues == rhs.associatedValues
    }
}

// MARK: - ExpressibleByArrayLiteral

extension RequestBody: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = BodyParameter

    public init(arrayLiteral elements: BodyParameter...) {
        self = .json(.init(arrayLiteral: elements))
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension RequestBody: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = BodyParameter

    public init(dictionaryLiteral elements: (String, BodyParameter)...) {
        let bodyParameter = elements.reduce(into: [String: BodyParameter]()) { $0[$1.0] = $1.1 }
        self = .json(.init(bodyParameter))
    }
}

// MARK: - ExpressibleByStringLiteral

extension RequestBody: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = .string(.init(stringLiteral: value))
    }
}
