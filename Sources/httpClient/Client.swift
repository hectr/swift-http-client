import Foundation

public final class Client {
    public var provider: NetworkProvider

    public var logger: Logger {
        get { provider.logger }
        set { provider.logger = newValue }
    }

    public init(provider: NetworkProvider) {
        self.provider = provider
    }

    private static func handleResult<T: Decodable>(logger: Logger,
                                                   result: Result<Data, Error>,
                                                   deserializer: Deserializer,
                                                   completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case let .success(data):
            do {
                let value: T = try deserializer.deserialize(data: data)
                completion(Result.success(value))
            } catch {
                let customError: Error
                if let error = error as? Error {
                    customError = error
                } else {
                    customError = Error.deserializationError(error)
                }
                logger.log(data: data, error: customError)
                completion(Result.failure(customError))
            }

        case let .failure(error):
            completion(Result.failure(error))
        }
    }

    @discardableResult
    public func performRequest<T: Decodable>(to endpoint: Endpoint,
                                             completion: @escaping (Result<T, Error>) -> Void) -> OngoingRequest? {
        let logger = self.logger
        return provider.performRequest(to: endpoint) { result in
            Self.handleResult(logger: logger,
                              result: result,
                              deserializer: endpoint.responseDeserializer,
                              completion: completion)
        }
    }
}
