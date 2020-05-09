import Foundation

public enum Body {
    case empty
    case string(CodableString)
    case data(Data)
    case json(BodyParameters)
    case formUrlEncoded(Parameters)
    case multipartFormData(MultipartParameters)

    public var contentHeader: Header {
        switch self {
        case .empty:
            return Parameter(key: "Content-Length", value: "0")

        case let .string(codableString):
            let charset = codableString
                .encoding
                .description
                .components(separatedBy: "Unicode (")
                .last?
                .components(separatedBy: ")")
                .first
                ?? ""
            if charset.hasPrefix("UTF-") {
                return Header(key: "Content-Type", value: "text/plain; charset=\(charset)")
            } else {
                return Header(key: "Content-Type", value: "text/plain")
            }

        case .data:
            return Header(key: "Content-Type", value: "application/octet-stream")

        case .json:
            return Header(key: "Content-Type", value: "application/json; charset=UTF-8")

        case .formUrlEncoded:
            return Header(key: "Content-Type", value: "application/x-www-form-urlencoded")

        case .multipartFormData:
            return Header(key: "Content-Type", value: "multipart/form-data")
        }
    }

    public var isEmpty: Bool {
        isCase.empty
    }

    public var isString: Bool {
        isCase.string
    }

    public var isData: Bool {
        isCase.data
    }

    public var isJson: Bool {
        isCase.json
    }

    public var isFormUrlEncoded: Bool {
        isCase.formUrlEncoded
    }

    public var isMultipartFormData: Bool {
        isCase.multipartFormData
    }

    private var isCase: (empty: Bool, string: Bool, data: Bool, json: Bool, formUrlEncoded: Bool, multipartFormData: Bool) {
        switch self {
        case .empty:
            return (empty: true, string: false, data: false, json: false, formUrlEncoded: false, multipartFormData: false)

        case .string:
            return (empty: false, string: true, data: false, json: false, formUrlEncoded: false, multipartFormData: false)

        case .data:
            return (empty: false, string: false, data: true, json: false, formUrlEncoded: false, multipartFormData: false)

        case .json:
            return (empty: false, string: false, data: false, json: true, formUrlEncoded: false, multipartFormData: false)

        case .formUrlEncoded:
            return (empty: false, string: false, data: false, json: false, formUrlEncoded: true, multipartFormData: false)

        case .multipartFormData:
            return (empty: false, string: false, data: false, json: false, formUrlEncoded: false, multipartFormData: true)
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

        case let .multipartFormData(multipartParameters):
            return (nil, nil, nil, nil, multipartParameters)
        }
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
        }
    }
}

// MARK: - Equatable

extension Body: Equatable {
    public static func == (lhs: Body, rhs: Body) -> Bool {
        lhs.associatedValues == rhs.associatedValues
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
