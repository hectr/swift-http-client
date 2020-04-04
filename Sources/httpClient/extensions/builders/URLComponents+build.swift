import Foundation

extension URLComponents {
    public var hasAuthorityComponent: Bool {
        user != nil || password != nil || host != nil || port != nil
    }

    public var isPathValidWithAuthorityComponent: Bool {
        path.isEmpty || path.hasPrefix("/")
    }

    public var isPathValidWithoutAuthorityComponent: Bool {
        path.isEmpty || !path.hasPrefix("//")
    }

    public func build() throws -> URL {
        if hasAuthorityComponent, !isPathValidWithAuthorityComponent {
            throw Error.invalidPathForAuthority(self)
        } else if !hasAuthorityComponent, !isPathValidWithoutAuthorityComponent {
            throw Error.invalidPath(self)
        } else if let url = url {
            return url
        } else {
            throw Error.malformedOutputURL(self)
        }
    }
}
