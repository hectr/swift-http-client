import Foundation

extension String {
    public func toURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw Error.invalidUrlString(self)
        }
        return url
    }
}
