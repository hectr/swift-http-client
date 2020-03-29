import Foundation
import httpClient

public class LoggerMock: Logger {
    public init() {}

    // MARK: log

    public var logEndpointCallsCount = 0
    public var logEndpointCalled: Bool {
        logEndpointCallsCount > 0
    }

    public var logEndpointReceivedEndpoint: Endpoint?
    public var logEndpointReceivedInvocations: [Endpoint] = []
    public var logEndpointClosure: ((Endpoint) -> Void)?

    public func log(endpoint: Endpoint) {
        logEndpointCallsCount += 1
        logEndpointReceivedEndpoint = endpoint
        logEndpointReceivedInvocations.append(endpoint)
        logEndpointClosure?(endpoint)
    }

    // MARK: log

    public var logEndpointErrorCallsCount = 0
    public var logEndpointErrorCalled: Bool {
        logEndpointErrorCallsCount > 0
    }

    public var logEndpointErrorReceivedArguments: (endpoint: Endpoint?, error: Error)?
    public var logEndpointErrorReceivedInvocations: [(endpoint: Endpoint?, error: Error)] = []
    public var logEndpointErrorClosure: ((Endpoint?, Error) -> Void)?

    public func log(endpoint: Endpoint?, error: Error) {
        logEndpointErrorCallsCount += 1
        logEndpointErrorReceivedArguments = (endpoint: endpoint, error: error)
        logEndpointErrorReceivedInvocations.append((endpoint: endpoint, error: error))
        logEndpointErrorClosure?(endpoint, error)
    }

    // MARK: log

    public var logRequestCallsCount = 0
    public var logRequestCalled: Bool {
        logRequestCallsCount > 0
    }

    public var logRequestReceivedRequest: URLRequest?
    public var logRequestReceivedInvocations: [URLRequest] = []
    public var logRequestClosure: ((URLRequest) -> Void)?

    public func log(request: URLRequest) {
        logRequestCallsCount += 1
        logRequestReceivedRequest = request
        logRequestReceivedInvocations.append(request)
        logRequestClosure?(request)
    }

    // MARK: log

    public var logRequestErrorCallsCount = 0
    public var logRequestErrorCalled: Bool {
        logRequestErrorCallsCount > 0
    }

    public var logRequestErrorReceivedArguments: (request: URLRequest?, error: Error)?
    public var logRequestErrorReceivedInvocations: [(request: URLRequest?, error: Error)] = []
    public var logRequestErrorClosure: ((URLRequest?, Error) -> Void)?

    public func log(request: URLRequest?, error: Error) {
        logRequestErrorCallsCount += 1
        logRequestErrorReceivedArguments = (request: request, error: error)
        logRequestErrorReceivedInvocations.append((request: request, error: error))
        logRequestErrorClosure?(request, error)
    }

    // MARK: log

    public var logResponseDataCallsCount = 0
    public var logResponseDataCalled: Bool {
        logResponseDataCallsCount > 0
    }

    public var logResponseDataReceivedArguments: (response: HTTPURLResponse?, data: Data)?
    public var logResponseDataReceivedInvocations: [(response: HTTPURLResponse?, data: Data)] = []
    public var logResponseDataClosure: ((HTTPURLResponse?, Data) -> Void)?

    public func log(response: HTTPURLResponse?, data: Data) {
        logResponseDataCallsCount += 1
        logResponseDataReceivedArguments = (response: response, data: data)
        logResponseDataReceivedInvocations.append((response: response, data: data))
        logResponseDataClosure?(response, data)
    }

    // MARK: log

    public var logResponseErrorCallsCount = 0
    public var logResponseErrorCalled: Bool {
        logResponseErrorCallsCount > 0
    }

    public var logResponseErrorReceivedArguments: (response: HTTPURLResponse?, error: Error)?
    public var logResponseErrorReceivedInvocations: [(response: HTTPURLResponse?, error: Error)] = []
    public var logResponseErrorClosure: ((HTTPURLResponse?, Error) -> Void)?

    public func log(response: HTTPURLResponse?, error: Error) {
        logResponseErrorCallsCount += 1
        logResponseErrorReceivedArguments = (response: response, error: error)
        logResponseErrorReceivedInvocations.append((response: response, error: error))
        logResponseErrorClosure?(response, error)
    }

    // MARK: log

    public var logDataErrorCallsCount = 0
    public var logDataErrorCalled: Bool {
        logDataErrorCallsCount > 0
    }

    public var logDataErrorReceivedArguments: (data: Data?, error: Error)?
    public var logDataErrorReceivedInvocations: [(data: Data?, error: Error)] = []
    public var logDataErrorClosure: ((Data?, Error) -> Void)?

    public func log(data: Data?, error: Error) {
        logDataErrorCallsCount += 1
        logDataErrorReceivedArguments = (data: data, error: error)
        logDataErrorReceivedInvocations.append((data: data, error: error))
        logDataErrorClosure?(data, error)
    }
}
