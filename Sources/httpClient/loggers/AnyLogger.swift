import Foundation

public struct AnyLogger: Logger {
    private var _logEndpoint: (Endpoint) -> Void
    private var _logRequest: (URLRequest) -> Void
    private var _logEndpointError: (Endpoint?, Error) -> Void
    private var _logRequestError: (URLRequest?, Error) -> Void
    private var _logResponseData: (HTTPURLResponse?, Data) -> Void
    private var _logResponseError: (HTTPURLResponse?, Error) -> Void
    private var _logDataError: (Data?, Error) -> Void

    public init<L: Logger>(_ logger: L) {
        self.init(logEndpoint: { logger.log(endpoint: $0) },
                  logEndpointError: { logger.log(endpoint: $0, error: $1) },
                  logRequest: { logger.log(request: $0) },
                  logRequestError: { logger.log(request: $0, error: $1) },
                  logResponseData: { logger.log(response: $0, data: $1) },
                  logResponseError: { logger.log(response: $0, error: $1) },
                  logDataError: { logger.log(data: $0, error: $1) })
    }

    public init(logEndpoint: @escaping (Endpoint) -> Void = { _ in },
                logEndpointError: @escaping (Endpoint?, Error) -> Void = { _, _ in },
                logRequest: @escaping (URLRequest) -> Void = { _ in },
                logRequestError: @escaping (URLRequest?, Error) -> Void = { _, _ in },
                logResponseData: @escaping (HTTPURLResponse?, Data) -> Void = { _, _ in },
                logResponseError: @escaping (HTTPURLResponse?, Error) -> Void = { _, _ in },
                logDataError: @escaping (Data?, Error) -> Void = { _, _ in }) {
        _logEndpoint = logEndpoint
        _logEndpointError = logEndpointError
        _logRequest = logRequest
        _logRequestError = logRequestError
        _logResponseData = logResponseData
        _logResponseError = logResponseError
        _logDataError = logDataError
    }

    public func log(endpoint: Endpoint) { _logEndpoint(endpoint) }
    public func log(endpoint: Endpoint?, error: Error) { _logEndpointError(endpoint, error) }
    public func log(request: URLRequest) { _logRequest(request) }
    public func log(request: URLRequest?, error: Error) { _logRequestError(request, error) }
    public func log(response: HTTPURLResponse?, data: Data) { _logResponseData(response, data) }
    public func log(response: HTTPURLResponse?, error: Error) { _logResponseError(response, error) }
    public func log(data: Data?, error: Error) { _logDataError(data, error) }
}
