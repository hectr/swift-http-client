import Foundation

public typealias Header = Parameter

public typealias Headers = Parameters

extension Headers {
    public func toHeaderFields() -> [String: String] {
        reduce(into: [String: String]()) { allFields, newField in
            if let oldValue = allFields[newField.key] {
                allFields[newField.key] = oldValue + "," + newField.value
            } else {
                allFields[newField.key] = newField.value
            }
        }
    }
}
