import Foundation
import httpClient
import XCTest

final class HTTPMethodTests: XCTestCase {
    func testIsExpressibleByString() {
        let method: HTTPMethod? = "head"
        XCTAssertEqual(method, .head)
    }

    func testLosslessStringConvertibleIgnoresCapitalization() {
        XCTAssertEqual(HTTPMethod("gEt"), .get)
        XCTAssertEqual(HTTPMethod("GET"), .get)
    }

    func testRawValueEnforcesCapitalization() {
        XCTAssertNil(HTTPMethod(rawValue: "put"))
        XCTAssertEqual(HTTPMethod(rawValue: "PUT"), .put)
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
    }

    func testDescriptionIsEqualToRawValue() {
        for method in HTTPMethod.allCases {
            XCTAssertEqual(method.rawValue, method.description)
        }
    }
}
