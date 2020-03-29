import Foundation

extension URL {
    public func toURLComponents(resolvingAgainstBaseURL flag: Bool = true) throws -> URLComponents {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: flag) else {
            throw Error.malformedInputUrl(self)
        }
        return components
    }
}
