import Foundation

public protocol NetworkProvider {
    typealias Completion = (Result<Data, Error>) -> Void

    var logger: Logger { get set }

    func performRequest(to endpoint: Endpoint,
                        completion: @escaping Completion) -> OngoingRequest?
}
