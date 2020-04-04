import Foundation

extension String {
    public func toInt() throws -> Int {
        guard let integer = Int(self) else {
            throw Error.invalidInt(self)
        }
        return integer
    }
}
