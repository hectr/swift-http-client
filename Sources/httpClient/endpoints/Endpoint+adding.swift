import Foundation

extension Endpoint {
    public func addingPathComponent(_ component: String) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.path = path
            .components(separatedBy: "/")
            .appending(component)
            .joined(separator: "/")
        return endpoint
    }

    public func addingQueryParameter(_ queryParameter: Parameter) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.queryParameters = queryParameters?.appending(queryParameter) ?? Parameters([queryParameter])
        return endpoint
    }

    public func addingHeader(_ header: Header) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.headers = headers.appending(header)
        return endpoint
    }
}
