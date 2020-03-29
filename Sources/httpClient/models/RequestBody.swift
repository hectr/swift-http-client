import Foundation

public enum RequestBody {
    case empty
    case data(Data)
    case formUrlEncoded(Parameters)
    case multipartformData([MultipartParameter])
}

// MARK: - Codable

extension RequestBody: Codable {
    enum CodingKeys: String, CodingKey {
        case caseName
        case data
        case parameters
        case multipartParameters
    }

    private var caseName: String {
        String(describing: self)
            .components(separatedBy: "(")
            .first
            ?? String(describing: self)
    }

    private var associatedData: Data? {
        switch self {
        case .empty, .formUrlEncoded, .multipartformData:
            return nil

        case let .data(data):
            return data
        }
    }

    private var associatedParameters: Parameters? {
        switch self {
        case .empty, .data, .multipartformData:
            return nil

        case let .formUrlEncoded(parameters):
            return parameters
        }
    }

    private var associatedMultipartParameters: [MultipartParameter]? {
        switch self {
        case .empty, .data, .formUrlEncoded:
            return nil

        case let .multipartformData(multipartParameters):
            return multipartParameters
        }
    }

    // MARK: Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let caseName = try container.decode(String.self, forKey: .caseName)
        let multipartParameters = try container.decodeIfPresent([MultipartParameter].self, forKey: .multipartParameters)
        let parameters = try container.decodeIfPresent(Parameters.self, forKey: .parameters)
        let data = try container.decodeIfPresent(Data.self, forKey: .data)

        if let value = multipartParameters {
            self = .multipartformData(value)
        } else if let value = parameters {
            self = .formUrlEncoded(value)
        } else if let value = data {
            self = .data(value)
        } else if caseName == RequestBody.empty.caseName {
            self = .empty
        } else {
            let debugDescription = "Unknown \(Self.self) case"
            let context = DecodingError.Context(codingPath: [], debugDescription: debugDescription)
            throw DecodingError.dataCorrupted(context)
        }
    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(caseName, forKey: .caseName)
        switch self {
        case .empty:
            break

        case let .data(data):
            try container.encode(data, forKey: .data)

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
        lhs.caseName == rhs.caseName
            && lhs.associatedData == rhs.associatedData
            && lhs.associatedParameters == rhs.associatedParameters
            && lhs.associatedMultipartParameters == rhs.associatedMultipartParameters
    }
}

// MARK: - ExpressibleByString

extension RequestBody: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let data = candidate.data(using: .utf8) else {
            return nil
        }
        self = .data(data)
    }
}
