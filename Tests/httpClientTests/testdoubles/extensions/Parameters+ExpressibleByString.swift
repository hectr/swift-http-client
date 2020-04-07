import Foundation
import httpClient

extension Parameters: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let queryItems = try? candidate.toURLQueryItems() else {
            return nil
        }
        let parameters = queryItems.map { $0.toParameter() }
        self = Parameters(parameters)
    }
}
