import Foundation

public struct MutableEndpoint<DeserializerType: Codable & Deserializer & Equatable>: Codable, Deserializer, Endpoint {
    public var method: HTTPMethod
    public var baseUrl: String
    public var path: String
    public var queryParameters: Parameters?

    public var body: Body

    public var cachePolicy: URLRequest.CachePolicy
    public var timeoutInterval: TimeInterval
    public var headers: Headers

    public var concreteDeserializer: DeserializerType
    public var responseDeserializer: Deserializer {
        concreteDeserializer
    }

    public var responseBodyExample: Body?

    public init(method: HTTPMethod = .get,
                baseUrl: String,
                path: String,
                queryParameters: Parameters?,
                body: Body = .empty,
                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                timeoutInterval: TimeInterval = 20.0,
                headers: Headers = [],
                concreteDeserializer: DeserializerType,
                responseBodyExample: Body? = nil) {
        self.method = method
        self.baseUrl = baseUrl
        self.path = path
        self.queryParameters = queryParameters
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.headers = headers
        self.concreteDeserializer = concreteDeserializer
        self.responseBodyExample = responseBodyExample
    }

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        try concreteDeserializer.deserialize(data: data)
    }
}

// MARK: - Equatable

extension MutableEndpoint: Equatable {
    public static func == (lhs: MutableEndpoint, rhs: MutableEndpoint) -> Bool {
        lhs.method == rhs.method
            && lhs.baseUrl == rhs.baseUrl
            && lhs.path == rhs.path
            && lhs.queryParameters == rhs.queryParameters
            && lhs.body == rhs.body
            && lhs.cachePolicy == rhs.cachePolicy
            && lhs.timeoutInterval == rhs.timeoutInterval
            && lhs.headers == rhs.headers
            && lhs.concreteDeserializer == rhs.concreteDeserializer
            && lhs.responseBodyExample == rhs.responseBodyExample
    }
}
