import Foundation

public final class URLRequestBuilder {
    private var urlRequest: URLRequest

    public init(url: URL) {
        urlRequest = URLRequest(url: url)
    }

    @discardableResult
    public func add(contentType: Parameter?) -> URLRequestBuilder {
        if let contentType = contentType {
            urlRequest.setValue(contentType.value, forHTTPHeaderField: contentType.key)
        }
        return self
    }

    @discardableResult
    public func add(httpHeaderField: Header) -> URLRequestBuilder {
        add(httpHeaderFields: Headers([httpHeaderField]))
    }

    @discardableResult
    public func add(httpHeaderFields: Headers) -> URLRequestBuilder {
        httpHeaderFields.forEach { parameter in
            urlRequest.addValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
        return self
    }

    public func build() -> URLRequest {
        urlRequest
    }

    @discardableResult
    public func set(httpBody: Data?) -> URLRequestBuilder {
        urlRequest.httpBody = httpBody
        return self
    }

    @discardableResult
    public func set(cachePolicy: URLRequest.CachePolicy) -> URLRequestBuilder {
        urlRequest.cachePolicy = cachePolicy
        return self
    }

    @discardableResult
    public func set(httpMethod: HTTPMethod) -> URLRequestBuilder {
        urlRequest.httpMethod = httpMethod.rawValue
        return self
    }

    @discardableResult
    public func set(timeoutInterval: TimeInterval) -> URLRequestBuilder {
        urlRequest.timeoutInterval = timeoutInterval
        return self
    }
}
