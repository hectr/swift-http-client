import Foundation

extension String {
    public func toURLQueryItems(percentEncoded: Bool = true) throws -> [URLQueryItem] {
        var components = URLComponents()
        if percentEncoded {
            components.percentEncodedQuery = self
        } else {
            components.query = self
        }
        guard let queryItems = components.queryItems else {
            let debugDescription = "Decoded string is not a valid percent encoded query"
            let context = DecodingError.Context(codingPath: [], debugDescription: debugDescription)
            throw DecodingError.dataCorrupted(context)
        }
        return queryItems
    }

    public func toURLQueryItem(percentEncoded: Bool = true) throws -> URLQueryItem {
        let queryItems = try toURLQueryItems(percentEncoded: percentEncoded)
        guard queryItems.count <= 1 else {
            let debugDescription = "Decoded string contains too many query items (expected 1, found \(queryItems.count)"
            let context = DecodingError.Context(codingPath: [], debugDescription: debugDescription)
            throw DecodingError.dataCorrupted(context)
        }
        guard let queryItem = queryItems.first else {
            let debugDescription = "Decoded string does not contain any query items: "
            let context = DecodingError.Context(codingPath: [], debugDescription: debugDescription)
            throw DecodingError.dataCorrupted(context)
        }
        return queryItem
    }
}
