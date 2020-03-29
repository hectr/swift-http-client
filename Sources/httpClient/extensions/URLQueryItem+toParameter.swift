import Foundation

extension URLQueryItem {
    public func toParameter() -> Parameter {
        Parameter(key: name, value: value ?? "")
    }
}
