import Foundation

public final class URLRequestBuilder {
    private var urlRequest: URLRequest

    public init(url: URL) {
        urlRequest = URLRequest(url: url)
    }

    @discardableResult
    public func add(contentType: Parameter?) -> Self {
        if let contentType = contentType {
            urlRequest.setValue(contentType.value, forHTTPHeaderField: contentType.key)
        }
        return self
    }

    @discardableResult
    public func add(httpHeaderField: Header) -> Self {
        add(httpHeaderFields: Headers([httpHeaderField]))
    }

    @discardableResult
    public func add(httpHeaderFields: Headers) -> Self {
        httpHeaderFields.forEach { parameter in
            urlRequest.addValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
        return self
    }

    public func build() -> URLRequest {
        urlRequest
    }

    @discardableResult
    public func set(httpBody: Data?) -> Self {
        urlRequest.httpBody = httpBody
        return self
    }

    @discardableResult
    public func set(cachePolicy: URLRequest.CachePolicy) -> Self {
        urlRequest.cachePolicy = cachePolicy
        return self
    }

    @discardableResult
    public func set(httpMethod: HTTPMethod) -> Self {
        urlRequest.httpMethod = httpMethod.rawValue
        return self
    }

    @discardableResult
    public func set(timeoutInterval: TimeInterval) -> Self {
        urlRequest.timeoutInterval = timeoutInterval
        return self
    }
}
