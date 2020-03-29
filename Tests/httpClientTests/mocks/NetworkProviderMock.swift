import Foundation
import httpClient

public class NetworkProviderMock: NetworkProvider {
    public init() {}

    public var logger: Logger {
        get { underlyingLogger }
        set(value) { underlyingLogger = value }
    }

    public var underlyingLogger: Logger!

    // MARK: performRequest

    public var performRequestToCompletionCallsCount = 0
    public var performRequestToCompletionCalled: Bool {
        performRequestToCompletionCallsCount > 0
    }

    public var performRequestToCompletionReceivedArguments: (endpoint: Endpoint, completion: Completion)?
    public var performRequestToCompletionReceivedInvocations: [(endpoint: Endpoint, completion: Completion)] = []
    public var performRequestToCompletionReturnValue: OngoingRequest?
    public var performRequestToCompletionClosure: ((Endpoint, @escaping Completion) -> OngoingRequest)?

    public func performRequest(to endpoint: Endpoint, completion: @escaping Completion) -> OngoingRequest? {
        performRequestToCompletionCallsCount += 1
        performRequestToCompletionReceivedArguments = (endpoint: endpoint, completion: completion)
        performRequestToCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        return performRequestToCompletionClosure.map { $0(endpoint, completion) } ?? performRequestToCompletionReturnValue
    }
}
