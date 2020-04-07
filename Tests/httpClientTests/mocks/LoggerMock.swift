import Foundation
import httpClient

class LoggerMock: Logger {
    init() {}

    // MARK: log

    var logEndpointCallsCount = 0
    var logEndpointCalled: Bool {
        logEndpointCallsCount > 0
    }

    var logEndpointReceivedEndpoint: Endpoint?
    var logEndpointReceivedInvocations: [Endpoint] = []
    var logEndpointClosure: ((Endpoint) -> Void)?

    func log(endpoint: Endpoint) {
        logEndpointCallsCount += 1
        logEndpointReceivedEndpoint = endpoint
        logEndpointReceivedInvocations.append(endpoint)
        logEndpointClosure?(endpoint)
    }

    // MARK: log

    var logEndpointErrorCallsCount = 0
    var logEndpointErrorCalled: Bool {
        logEndpointErrorCallsCount > 0
    }

    var logEndpointErrorReceivedArguments: (endpoint: Endpoint?, error: Error)?
    var logEndpointErrorReceivedInvocations: [(endpoint: Endpoint?, error: Error)] = []
    var logEndpointErrorClosure: ((Endpoint?, Error) -> Void)?

    func log(endpoint: Endpoint?, error: Error) {
        logEndpointErrorCallsCount += 1
        logEndpointErrorReceivedArguments = (endpoint: endpoint, error: error)
        logEndpointErrorReceivedInvocations.append((endpoint: endpoint, error: error))
        logEndpointErrorClosure?(endpoint, error)
    }

    // MARK: log

    var logRequestCallsCount = 0
    var logRequestCalled: Bool {
        logRequestCallsCount > 0
    }

    var logRequestReceivedRequest: URLRequest?
    var logRequestReceivedInvocations: [URLRequest] = []
    var logRequestClosure: ((URLRequest) -> Void)?

    func log(request: URLRequest) {
        logRequestCallsCount += 1
        logRequestReceivedRequest = request
        logRequestReceivedInvocations.append(request)
        logRequestClosure?(request)
    }

    // MARK: log

    var logRequestErrorCallsCount = 0
    var logRequestErrorCalled: Bool {
        logRequestErrorCallsCount > 0
    }

    var logRequestErrorReceivedArguments: (request: URLRequest?, error: Error)?
    var logRequestErrorReceivedInvocations: [(request: URLRequest?, error: Error)] = []
    var logRequestErrorClosure: ((URLRequest?, Error) -> Void)?

    func log(request: URLRequest?, error: Error) {
        logRequestErrorCallsCount += 1
        logRequestErrorReceivedArguments = (request: request, error: error)
        logRequestErrorReceivedInvocations.append((request: request, error: error))
        logRequestErrorClosure?(request, error)
    }

    // MARK: log

    var logResponseDataCallsCount = 0
    var logResponseDataCalled: Bool {
        logResponseDataCallsCount > 0
    }

    var logResponseDataReceivedArguments: (response: HTTPURLResponse?, data: Data)?
    var logResponseDataReceivedInvocations: [(response: HTTPURLResponse?, data: Data)] = []
    var logResponseDataClosure: ((HTTPURLResponse?, Data) -> Void)?

    func log(response: HTTPURLResponse?, data: Data) {
        logResponseDataCallsCount += 1
        logResponseDataReceivedArguments = (response: response, data: data)
        logResponseDataReceivedInvocations.append((response: response, data: data))
        logResponseDataClosure?(response, data)
    }

    // MARK: log

    var logResponseErrorCallsCount = 0
    var logResponseErrorCalled: Bool {
        logResponseErrorCallsCount > 0
    }

    var logResponseErrorReceivedArguments: (response: HTTPURLResponse?, error: Error)?
    var logResponseErrorReceivedInvocations: [(response: HTTPURLResponse?, error: Error)] = []
    var logResponseErrorClosure: ((HTTPURLResponse?, Error) -> Void)?

    func log(response: HTTPURLResponse?, error: Error) {
        logResponseErrorCallsCount += 1
        logResponseErrorReceivedArguments = (response: response, error: error)
        logResponseErrorReceivedInvocations.append((response: response, error: error))
        logResponseErrorClosure?(response, error)
    }

    // MARK: log

    var logDataErrorCallsCount = 0
    var logDataErrorCalled: Bool {
        logDataErrorCallsCount > 0
    }

    var logDataErrorReceivedArguments: (data: Data?, error: Error)?
    var logDataErrorReceivedInvocations: [(data: Data?, error: Error)] = []
    var logDataErrorClosure: ((Data?, Error) -> Void)?

    func log(data: Data?, error: Error) {
        logDataErrorCallsCount += 1
        logDataErrorReceivedArguments = (data: data, error: error)
        logDataErrorReceivedInvocations.append((data: data, error: error))
        logDataErrorClosure?(data, error)
    }
}
