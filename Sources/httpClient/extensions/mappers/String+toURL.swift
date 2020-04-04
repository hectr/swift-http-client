import Foundation

extension String {
    public func toURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw Error.invalidUrl(self)
        }
        return url
    }
}
