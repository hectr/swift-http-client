import Foundation

extension String {
    public func toData(encoding: Encoding = .utf8) throws -> Data {
        guard let data = data(using: encoding) else {
            throw Error.stringNotSerializable(self, encoding)
        }
        return data
    }
}
