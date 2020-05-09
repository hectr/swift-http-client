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
            if let bodyData = Self.convertToData(from: endpoint.responseBodyExample) {
                logger.log(response: HTTPURLResponse(), data: bodyData)
                completion(Result<Data, Error>.success(bodyData))
            } else {
                let error = Error.invalidResponseBodyExample(endpoint)
                logger.log(request: request, error: error)
                completion(Result<Data, Error>.failure(error))
            }
        }
        return Task()
    }

    static func convertToData(from body: Body?) -> Data? {
        guard let body = body else {
            return nil
        }
        switch body {
        case .empty:
            return Data()

        case let .string(codableString):
            return codableString.string.data(using: codableString.encoding)

        case let .data(data):
            return data

        case let .json(bodyParameters):
            return try? bodyParameters.toJSONData()

        case let .formUrlEncoded(parameters):
            return parameters.toURLComponents().percentEncodedQuery?.data(using: .utf8)

        case .multipartFormData:
            assertionFailure("Unsupported response example body: \(body)")
            return nil
        }
    }
}
