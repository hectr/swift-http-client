import Foundation

public struct MockingNetworkProvider: NetworkProvider {
    private struct Task: OngoingRequest {}

    public var logger: Logger

    public init(logger: Logger = AnyLogger()) {
        self.logger = logger
    }

    public func performRequest(to endpoint: Endpoint, completion: @escaping Self.Completion) -> OngoingRequest? {
        logger.log(endpoint: endpoint)
        let request: URLRequest
        do {
            request = try URLRequest.build(with: endpoint)
            logger.log(request: request)
        } catch {
            let customError = Error.unconvertibleToURLRequest(endpoint, underlyingError: error)
            logger.log(endpoint: endpoint, error: customError)
            completion(Result<Data, Error>.failure(customError))
            return nil
        }
        defer {
            if let responseBodyExample = endpoint.responseBodyExample {
                logger.log(response: HTTPURLResponse(), data: responseBodyExample)
                completion(Result<Data, Error>.success(responseBodyExample))
            } else {
                let error = Error.missingResponseBodyExample(endpoint)
                logger.log(request: request, error: error)
                completion(Result<Data, Error>.failure(error))
            }
        }
        return Task()
    }
}
