import Foundation
import httpClient

extension Parameter: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let queryItem = try? candidate.toURLQueryItem() else {
            return nil
        }
        self = queryItem.toParameter()
    }
}
