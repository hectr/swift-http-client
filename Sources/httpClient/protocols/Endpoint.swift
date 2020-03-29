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
