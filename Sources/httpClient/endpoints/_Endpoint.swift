import Foundation

struct _Endpoint: Endpoint {
    var method: HTTPMethod
    var baseUrl: String
    var path: String
    var queryParameters: Parameters?

    var body: Body

    var cachePolicy: URLRequest.CachePolicy
    var timeoutInterval: TimeInterval
    var httpHeaderFields: Headers

    var responseDeserializer: Deserializer
    var responseBodyExample: Body?

    init(method: HTTPMethod = .get,
                baseUrl: String,
                path: String,
                queryParameters: Parameters?,
                body: Body = .empty,
                cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                timeoutInterval: TimeInterval = 20.0,
                httpHeaderFields: Headers = [],
                responseDeserializer: Deserializer,
                responseBodyExample: Body? = nil) {
        self.method = method
        self.baseUrl = baseUrl
        self.path = path
        self.queryParameters = queryParameters
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.httpHeaderFields = httpHeaderFields
        self.responseDeserializer = responseDeserializer
        self.responseBodyExample = responseBodyExample
    }

    init(_ endpoint: Endpoint) {
        self.init(method: endpoint.method,
            baseUrl: endpoint.baseUrl,
            path: endpoint.path,
            queryParameters: endpoint.queryParameters,
            body: endpoint.body,
            cachePolicy: endpoint.cachePolicy,
            timeoutInterval: endpoint.timeoutInterval,
            httpHeaderFields: endpoint.httpHeaderFields,
            responseDeserializer: endpoint.responseDeserializer,
            responseBodyExample: endpoint.responseBodyExample)
    }
}
