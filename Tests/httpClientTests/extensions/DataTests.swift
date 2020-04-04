import Foundation
import httpClient
import XCTest

final class DataTests: XCTestCase {
    func testExpressibleByString() {
        let data: Data! = "some text"
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, "some text")
    }
}
