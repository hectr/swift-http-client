import Foundation

struct _Endpoint: Endpoint {
    var method: HTTPMethod
    var baseUrl: String
    var path: String
    var query: Parameters?

    var body: Body

    var cachePolicy: URLRequest.CachePolicy
    var timeoutInterval: TimeInterval
    var headers: Headers

    var responseDeserializer: Deserializer
    var responseBodyExample: Body?

    init(method: HTTPMethod = .get,
         baseUrl: String,
         path: String,
         query: Parameters?,
         body: Body = .empty,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
         timeoutInterval: TimeInterval = 20.0,
         headers: Headers = [],
         responseDeserializer: Deserializer,
         responseBodyExample: Body? = nil) {
        self.method = method
        self.baseUrl = baseUrl
        self.path = path
        self.query = query
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.headers = headers
        self.responseDeserializer = responseDeserializer
        self.responseBodyExample = responseBodyExample
    }

    init(_ endpoint: Endpoint) {
        self.init(method: endpoint.method,
                  baseUrl: endpoint.baseUrl,
                  path: endpoint.path,
                  query: endpoint.query,
                  body: endpoint.body,
                  cachePolicy: endpoint.cachePolicy,
                  timeoutInterval: endpoint.timeoutInterval,
                  headers: endpoint.headers,
                  responseDeserializer: endpoint.responseDeserializer,
                  responseBodyExample: endpoint.responseBodyExample)
    }
}
