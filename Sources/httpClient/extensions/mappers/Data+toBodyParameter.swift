import Foundation

extension Data {
    func toBodyParameter(options: JSONSerialization.ReadingOptions = [.fragmentsAllowed]) throws -> BodyParameter {
        let object = try JSONSerialization.jsonObject(with: self, options: options)
        guard let bodyParameter = object as? BodyParameter else {
            throw Error.invalidBodyParameter(object, self)
        }
        return bodyParameter
    }
}
