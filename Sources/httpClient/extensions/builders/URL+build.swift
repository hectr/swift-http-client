import Foundation

extension URL {
    public static func build(with endpoint: Endpoint) throws -> Self {
        try URLBuilder(baseUrl: endpoint.baseUrl)
            .add(parameters: endpoint.query)
            .add(path: endpoint.path)
            .build()
    }
}
