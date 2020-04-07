import Foundation
import httpClient

extension URL: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let url = try? candidate.toURL() else {
            return nil
        }
        self = url
    }
}
