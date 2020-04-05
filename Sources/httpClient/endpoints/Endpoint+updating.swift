import Foundation

extension Endpoint {
    public func updatingMethod(to method: HTTPMethod) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.method = method
        return endpoint
    }

    public func updatingBaseUrl(to baseUrl: String) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.baseUrl = baseUrl
        return endpoint
    }

    public func updatingPath(to path: String) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.path = path
        return endpoint
    }

    public func updatingQueryParameters(to queryParameters: Parameters?) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.queryParameters = queryParameters
        return endpoint
    }

    public func updatingBody(to body: Body) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.body = body
        return endpoint
    }

    public func updatingCachePolicy(to cachePolicy: URLRequest.CachePolicy) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.cachePolicy = cachePolicy
        return endpoint
    }

    public func updatingTimeoutInterval(to timeoutInterval: TimeInterval) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.timeoutInterval = timeoutInterval
        return endpoint
    }

    public func updatingHTTPHeaderFields(to httpHeaderFields: Headers) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.httpHeaderFields = httpHeaderFields
        return endpoint
    }

    public func updatingResponseDeserializer(to responseDeserializer: Deserializer) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.responseDeserializer = responseDeserializer
        return endpoint
    }

    public func updatingResponseBodyExample(to responseBodyExample: Body?) -> Endpoint {
        var endpoint = _Endpoint(self)
        endpoint.responseBodyExample = responseBodyExample
        return endpoint
    }
}
