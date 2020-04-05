import Foundation
import httpClient

public class EndpointMock: Endpoint {
    public init() {}

    public var method: HTTPMethod {
        get { underlyingMethod }
        set(value) { underlyingMethod = value }
    }

    public var underlyingMethod: HTTPMethod!

    public var baseUrl: String {
        get { underlyingBaseUrl }
        set(value) { underlyingBaseUrl = value }
    }

    public var underlyingBaseUrl: String!

    public var path: String {
        get { underlyingPath }
        set(value) { underlyingPath = value }
    }

    public var underlyingPath: String!

    public var queryParameters: Parameters?

    public var body: Body {
        get { underlyingBody }
        set(value) { underlyingBody = value }
    }

    public var underlyingBody: Body!

    public var cachePolicy: URLRequest.CachePolicy {
        get { underlyingCachePolicy }
        set(value) { underlyingCachePolicy = value }
    }

    public var underlyingCachePolicy: URLRequest.CachePolicy!

    public var timeoutInterval: TimeInterval {
        get { underlyingTimeoutInterval }
        set(value) { underlyingTimeoutInterval = value }
    }

    public var underlyingTimeoutInterval: TimeInterval!

    public var httpHeaderFields: Headers = []

    public var responseDeserializer: Deserializer {
        get { underlyingResponseDeserializer }
        set(value) { underlyingResponseDeserializer = value }
    }

    public var underlyingResponseDeserializer: Deserializer!

    public var responseBodyExample: Data?
}
