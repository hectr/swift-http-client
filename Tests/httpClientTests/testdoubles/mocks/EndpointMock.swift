import Foundation
import httpClient

class EndpointMock: Endpoint {
    init() {}

    var method: HTTPMethod {
        get { underlyingMethod }
        set(value) { underlyingMethod = value }
    }

    var underlyingMethod: HTTPMethod!

    var baseUrl: String {
        get { underlyingBaseUrl }
        set(value) { underlyingBaseUrl = value }
    }

    var underlyingBaseUrl: String!

    var path: String {
        get { underlyingPath }
        set(value) { underlyingPath = value }
    }

    var underlyingPath: String!

    var queryParameters: Parameters?

    var body: Body {
        get { underlyingBody }
        set(value) { underlyingBody = value }
    }

    var underlyingBody: Body!

    var cachePolicy: URLRequest.CachePolicy {
        get { underlyingCachePolicy }
        set(value) { underlyingCachePolicy = value }
    }

    var underlyingCachePolicy: URLRequest.CachePolicy!

    var timeoutInterval: TimeInterval {
        get { underlyingTimeoutInterval }
        set(value) { underlyingTimeoutInterval = value }
    }

    var underlyingTimeoutInterval: TimeInterval!

    var headers: Headers = []

    var responseDeserializer: Deserializer {
        get { underlyingResponseDeserializer }
        set(value) { underlyingResponseDeserializer = value }
    }

    var underlyingResponseDeserializer: Deserializer!

    var responseBodyExample: Body?
}
