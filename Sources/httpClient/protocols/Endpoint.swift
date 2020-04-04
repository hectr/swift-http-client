import Foundation

public protocol Endpoint {
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var path: String { get }
    var queryParameters: Parameters? { get }

    var body: RequestBody { get }

    var cachePolicy: URLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
    var httpHeaderFields: Headers { get }

    var responseDeserializer: Deserializer { get }
    var responseBodyExample: Data? { get }

    func updatingMethod(to method: HTTPMethod) -> Endpoint
    func updatingBaseUrl(to baseUrl: String) -> Endpoint
    func updatingPath(to path: String) -> Endpoint
    func updatingQueryParameters(to queryParameters: Parameters) -> Endpoint
    func updatingBody(to body: RequestBody) -> Endpoint
    func updatingCachePolicy(to cachePolicy: URLRequest.CachePolicy) -> Endpoint
    func updatingTimeoutInterval(to timeoutInterval: TimeInterval) -> Endpoint
    func updatingHTTPHeaderFields(to httpHeaderFields: Headers) -> Endpoint
    func updatingResponseDeserializer(to responseDeserializer: Deserializer) -> Endpoint
    func updatingResponseBodyExample(to responseBodyExample: Data) -> Endpoint
}

// MARK: - Default values

extension Endpoint {
    public var method: HTTPMethod { .get }
    public var queryParameters: Parameters? { nil }

    public var body: RequestBody { .empty }

    public var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    public var timeoutInterval: TimeInterval { 20.0 }
    public var httpHeaderFields: Headers { [] }

    public var responseDeserializer: Deserializer { JSONDeserializer() }
    public var responseBodyExample: Data? { nil }
}
