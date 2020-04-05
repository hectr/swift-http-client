import Foundation

extension URL {
    public static func build(with endpoint: Endpoint) throws -> URL {
        try URLBuilder(baseUrl: endpoint.baseUrl)
            .add(parameters: endpoint.queryParameters)
            .add(path: endpoint.path)
            .build()
    }
}
