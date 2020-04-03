import Foundation

extension String {
    public func toDouble() throws -> Double {
        guard let double = Double(self) else {
            throw Error.invalidDoubleString(self)
        }
        return double
    }
}
