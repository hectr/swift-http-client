import Foundation
import httpClient
import XCTest

final class StringTests: XCTestCase {
    func testToURL() throws {
        let someUrlString = "http://example.org/"
        let url = try someUrlString.toURL()
        XCTAssertEqual(url.absoluteString, someUrlString)
    }

    func testToURLError() {
        let someUrlString = "invalid URL"
        XCTAssertThrowsError(try someUrlString.toURL())
    }

    func testToURLQueryItem() throws {
        let someQueryString = "aa=bb"
        let queryItem = try someQueryString.toURLQueryItem()
        XCTAssertEqual(queryItem.name, someQueryString.components(separatedBy: "=").first)
        XCTAssertEqual(queryItem.value, someQueryString.components(separatedBy: "=").last)
    }
}
