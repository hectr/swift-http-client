import Foundation
import httpClient
import XCTest

final class HTTPMethodTests: XCTestCase {
    func testIsExpressibleByStringLiteral() {
        let method: HTTPMethod = "head"
        XCTAssertEqual(method.verb, HTTPMethod.head.verb.lowercased())
    }

    func testLosslessStringConvertibleIgnoresCapitalization() {
        XCTAssertEqual(HTTPMethod("gEt").verb.uppercased(), HTTPMethod.get.verb)
        XCTAssertEqual(HTTPMethod("GET"), .get)
    }

    func testDescriptionIsEqualToRawValue() {
        let stdMethods: [HTTPMethod] = [.connect, .delete, .get, .head, .options, .patch, .post, .put, .trace]
        for method in stdMethods {
            XCTAssertEqual(method.verb, method.description)
        }
    }
}
