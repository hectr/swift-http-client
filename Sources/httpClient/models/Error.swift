import Foundation

public enum Error: Swift.Error {
    case decodingError(DecodingError)
    case deserializationError(Swift.Error)
    case invalidBodyParameter(Any, Data)
    case invalidInt(String)
    case invalidDate(String)
    case invalidDouble(String)
    case invalidPath(URLComponents)
    case invalidPathForAuthority(URLComponents)
    case invalidUrl(String)
    case invalidURLQueryItems(String)
    case tooManyURLQueryItems(String, [URLQueryItem])
    case noUrlQueryItemsFound(String)
    case malformedInputURL(URL)
    case malformedOutputURL(URLComponents)
    case invalidResponseBodyExample(Endpoint)
    case stringNotDeserializable(Data, String.Encoding)
    case stringNotSerializable(String, String.Encoding)
    case typeMismatch(expected: Any.Type, found: Any.Type)
    case unconvertibleToURLRequest(Endpoint, Swift.Error)
    case unhandledError(Swift.Error)
    case urlError(URLError)

    public init(_ error: Swift.Error) {
        if let error = error as? DecodingError {
            self = .decodingError(error)
        } else if let error = error as? Error {
            self = error
        } else if let error = error as? URLError {
            self = .urlError(error)
        } else {
            self = .unhandledError(error)
        }
    }
}
