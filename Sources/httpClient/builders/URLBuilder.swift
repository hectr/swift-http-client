import Foundation
import Idioms

public final class URLBuilder {
    private var components: URLComponents

    public init(baseUrl: String) throws {
        components = try baseUrl
            .toURL()
            .toURLComponents()
    }

    @discardableResult
    public func add(path: String) throws -> Self {
        var url = try components.build()
        url.appendPathComponent(path)
        components.path = url.path
        return self
    }

    @discardableResult
    public func add(parameter: Parameter) -> Self {
        add(parameters: Parameters([parameter]))
    }

    @discardableResult
    public func add(parameters: Parameters?) -> Self {
        guard let parameters = parameters else {
            return self
        }
        let queryItems = parameters.map { $0.toURLQueryItem() }
        add(queries: queryItems)
        return self
    }

    public func build() throws -> URL {
        try components.build()
    }

    private func add(queries: [URLQueryItem]) {
        components.queryItems = components
            .queryItems?
            .appending(contentsOf: queries)
            ?? queries
    }
}
