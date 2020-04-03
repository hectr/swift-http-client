import Foundation

extension Date: ExpressibleByString {
    public init?(stringRepresentation candidate: String) {
        guard let date = try? candidate.toDate() else {
            return nil
        }
        self = date
    }
}
