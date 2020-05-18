import Foundation

public protocol BodySerializer {
    func contentHeaders() -> Headers
    func contentData() throws -> Data
    func toCurlBody() -> [String]
}
