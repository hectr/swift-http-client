import Foundation
import httpClient
import XCTest

final class DataTests: XCTestCase {
    func testInitDataFromString() {
        let data: Data? = "some text"
        XCTAssertNotNil(data)
    }

    func testEncoding() {
        let data: Data! = "some text"
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, "some text")
    }
}
