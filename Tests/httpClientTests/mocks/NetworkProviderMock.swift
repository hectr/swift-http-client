import Foundation
import httpClient

class NetworkProviderMock: NetworkProvider {
    init() {}

    var logger: Logger {
        get { underlyingLogger }
        set(value) { underlyingLogger = value }
    }

    var underlyingLogger: Logger!

    // MARK: performRequest

    var performRequestToCompletionCallsCount = 0
    var performRequestToCompletionCalled: Bool {
        performRequestToCompletionCallsCount > 0
    }

    var performRequestToCompletionReceivedArguments: (endpoint: Endpoint, completion: Completion)?
    var performRequestToCompletionReceivedInvocations: [(endpoint: Endpoint, completion: Completion)] = []
    var performRequestToCompletionReturnValue: OngoingRequest?
    var performRequestToCompletionClosure: ((Endpoint, @escaping Completion) -> OngoingRequest)?

    func performRequest(to endpoint: Endpoint, completion: @escaping Completion) -> OngoingRequest? {
        performRequestToCompletionCallsCount += 1
        performRequestToCompletionReceivedArguments = (endpoint: endpoint, completion: completion)
        performRequestToCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        return performRequestToCompletionClosure.map { $0(endpoint, completion) } ?? performRequestToCompletionReturnValue
    }
}
