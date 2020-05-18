import Foundation

public enum Body: BodySerializer {
    case empty
    case string(CodableString)
    case data(Data)
    case json(BodyParameters)
    case formUrlEncoded(Parameters)
    case multipartFormData(MultipartParameters)
    case custom(AnyBodySerializer)

    public func contentHeaders() -> Headers {
        underlyingSerializer.contentHeaders()
    }

    public func contentData() throws -> Data {
        try underlyingSerializer.contentData()
    }

    public func toCurlBody() -> [String] {
        underlyingSerializer.toCurlBody()
    }

    private var underlyingSerializer: AnyBodySerializer {
        switch self {
        case .empty:
            return AnyBodySerializer(EmptySerializer())

        case let .string(encodableString):
            return AnyBodySerializer(StringSerializer(encodableString))

        case let .data(data):
            return AnyBodySerializer(DataSerializer(data))

        case let .json(bodyParameters):
            return AnyBodySerializer(JsonSerializer(bodyParameters))

        case let .formUrlEncoded(parameters):
            return AnyBodySerializer(FormUrlEncodedSerializer(parameters))

        case let .multipartFormData(multipartParameters):
            return AnyBodySerializer(MultipartFormDataSerializer(multipartParameters))

        case let .custom(bodySerializer):
            return bodySerializer
        }
    }
}

// MARK: - Codable

extension Body: Codable {
    enum CodingKeys: String, CodingKey {
        case string
        case data
        case json
        case parameters
        case multipartParameters
        case bodySerializer
    }

    // MARK: Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(MultipartParameters.self, forKey: .multipartParameters) {
            self = .multipartFormData(value)
        } else if let value = try container.decodeIfPresent(Parameters.self, forKey: .parameters) {
            self = .formUrlEncoded(value)
        } else if let value = try container.decodeIfPresent(BodyParameters.self, forKey: .json) {
            self = .json(value)
        } else if let value = try container.decodeIfPresent(Data.self, forKey: .data) {
            self = .data(value)
        } else if let value = try container.decodeIfPresent(CodableString.self, forKey: .string) {
            self = .string(value)
        } else if let value = try container.decodeIfPresent(AnyBodySerializer.self, forKey: .bodySerializer) {
            self = .custom(value)
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

        case let .multipartFormData(multipartParameters):
            try container.encode(multipartParameters, forKey: .multipartParameters)

        case let .custom(bodySerializer):
            try container.encode(bodySerializer, forKey: .bodySerializer)
        }
    }
}

// MARK: - Equatable

extension Body: Equatable {
    public static func == (lhs: Body, rhs: Body) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true

        case let (.string(lhs), .string(rhs)):
            return lhs == rhs

        case let (.data(lhs), .data(rhs)):
            return lhs == rhs

        case let (.json(lhs), .json(rhs)):
            return lhs == rhs

        case let (.formUrlEncoded(lhs), .formUrlEncoded(rhs)):
            return lhs == rhs

        case let (.multipartFormData(lhs), .multipartFormData(rhs)):
            return lhs == rhs

        case let (.custom(lhs), .custom(rhs)):
            return lhs == rhs

        default:
            return false
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension Body: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = BodyParameter

    public init(arrayLiteral elements: BodyParameter...) {
        self = .json(.init(arrayLiteral: elements))
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension Body: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = BodyParameter

    public init(dictionaryLiteral elements: (String, BodyParameter)...) {
        let bodyParameter = elements.reduce(into: [String: BodyParameter]()) { $0[$1.0] = $1.1 }
        self = .json(.init(bodyParameter))
    }
}

// MARK: - ExpressibleByStringLiteral

extension Body: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public init(stringLiteral value: String) {
        self = .string(.init(stringLiteral: value))
    }
}
