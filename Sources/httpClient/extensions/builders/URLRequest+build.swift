import Foundation

extension URLRequest {
    public static func build(with endpoint: Endpoint) throws -> Self {
        let url = try URL.build(with: endpoint)
        let request = URLRequestBuilder(url: url)
            .add(httpHeaderFields: endpoint.headers)
            .set(cachePolicy: endpoint.cachePolicy)
            .set(httpMethod: endpoint.method)
            .set(timeoutInterval: endpoint.timeoutInterval)
            .build()
        return request
    }
}
