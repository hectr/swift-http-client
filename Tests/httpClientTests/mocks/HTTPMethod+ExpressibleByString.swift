import Foundation
import httpClient

extension HTTPMethod: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        self.init(candidate)
    }
}
