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
            let customError = Error.unconvertibleToURLRequest(endpoint, error)
            logger.log(endpoint: endpoint, error: customError)
            completion(Result<Data, Error>.failure(customError))
            return nil
        }
        defer {
            do {
                completion(try result(for: endpoint))
            } catch {
                let customError = Error(error)
                logger.log(request: request, error: customError)
                completion(Result<Data, Error>.failure(customError))
            }
        }
        return Task()
    }

    static func convertToData(from body: Body?) throws -> Data? {
        guard let body = body else {
            return nil
        }
        return try body.contentData()
    }

    private func result(for endpoint: Endpoint) throws -> Result<Data, Error> {
        if let bodyData = try Self.convertToData(from: endpoint.responseBodyExample) {
            logger.log(response: HTTPURLResponse(), data: bodyData)
            return Result<Data, Error>.success(bodyData)
        } else {
            throw Error.invalidResponseBodyExample(endpoint)
        }
    }
}
