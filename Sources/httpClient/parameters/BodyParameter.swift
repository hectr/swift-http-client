import Foundation

public struct _BodyParameterDescription: Codable, Equatable {
    private let key: String
    private let value: String

    fileprivate init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

public protocol BodyParameter {
    func toJSONData(options: JSONSerialization.WritingOptions) throws -> Data
    func _visitParameter() -> [_BodyParameterDescription]
}

extension BodyParameter {
    public func toJSONData(options: JSONSerialization.WritingOptions = [.fragmentsAllowed]) throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: options)
    }
}

extension Bool: BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        return [_BodyParameterDescription("\(Self.self)", "\(self)")]
    }
}

extension Int: BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        return [_BodyParameterDescription("\(Self.self)", "\(self)")]
    }
}

extension Double: BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        return [_BodyParameterDescription("\(Self.self)", "\(self)")]
    }
}

extension String: BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        return [_BodyParameterDescription("\(Self.self)", "\(self)")]
    }
}

extension Array: BodyParameter where Element == BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        reduce(into: [_BodyParameterDescription]()) { result, element in
            result.append(_BodyParameterDescription("\(result.count)", "\(element._visitParameter())"))
        }
    }
}

extension Dictionary: BodyParameter where Key == String, Value == BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        sorted { $0.0 < $1.0 }
            .reduce(into: [_BodyParameterDescription]()) { result, element in
                result.append(_BodyParameterDescription("\"\(element.key)\"", "\(element.value._visitParameter())"))
            }
    }
}

extension Optional: BodyParameter where Wrapped == BodyParameter {
    public func _visitParameter() -> [_BodyParameterDescription] {
        self?._visitParameter() ?? [_BodyParameterDescription("\(Wrapped.self)", "nil")]
    }
}
