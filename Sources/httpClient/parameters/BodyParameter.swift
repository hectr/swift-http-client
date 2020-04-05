import Foundation

public protocol BodyParameter {
    func toJSONData(options: JSONSerialization.WritingOptions) throws -> Data
}

extension BodyParameter {
    public func toJSONData(options: JSONSerialization.WritingOptions = [.fragmentsAllowed]) throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: options)
    }
}

extension Bool: BodyParameter {}
extension Int: BodyParameter {}
extension Double: BodyParameter {}
extension String: BodyParameter {}
extension Array: BodyParameter where Element == BodyParameter {}
extension Dictionary: BodyParameter where Key == String, Value == BodyParameter {}
extension Optional: BodyParameter where Wrapped == BodyParameter {}
