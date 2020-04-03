import Foundation

extension Data: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let data = candidate.data(using: .utf8) else {
            return nil
        }
        self = data
    }
}
