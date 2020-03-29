import Foundation

public enum Error: Swift.Error {
    case decodingError(DecodingError)
    case deserializationError(Swift.Error)
    case invalidPath(URLComponents)
    case invalidPathForAuthority(URLComponents)
    case invalidUrlString(String)
    case malformedInputUrl(URL)
    case malformedOutputUrl(URLComponents)
    case missingResponseBodyExample(Endpoint)
    case networkingError(Swift.Error)
    case stringNotDeserializable(Data, String.Encoding)
    case typeMismatch(expected: Any.Type, found: Any.Type)
    case unconvertibleToURLRequest(Endpoint, underlyingError: Swift.Error)
    case urlError(URLError)

    public init(_ error: Swift.Error) {
        if let error = error as? Error {
            self = error
        } else if let error = error as? DecodingError {
            self = .decodingError(error)
        } else if let error = error as? URLError {
            self = .urlError(error)
        } else {
            self = .networkingError(error)
        }
    }
}
