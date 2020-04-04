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
            throw Error.invalidURLQueryItems(self)
        }
        return queryItems
    }

    public func toURLQueryItem(percentEncoded: Bool = true) throws -> URLQueryItem {
        let queryItems = try toURLQueryItems(percentEncoded: percentEncoded)
        guard queryItems.count <= 1 else {
            throw Error.tooManyURLQueryItems(self, queryItems)
        }
        guard let queryItem = queryItems.first else {
            throw Error.noUrlQueryItemsFound(self)
        }
        return queryItem
    }
}
