import Foundation
import httpClient
import XCTest

final class URLTests: XCTestCase {
    func testExpressibleByString() {
        let url: URL? = "some.url"
        let expectedURL = URL(string: "some.url")
        XCTAssertEqual(url, expectedURL)
    }

    func testToURLComponents() throws {
        let someURL: URL! = "http://example.org/some/path?someKey=someValue"
        let components = try someURL.toURLComponents()
        XCTAssertEqual(components.host, "example.org")
        XCTAssertEqual(components.path, "/some/path")
        XCTAssertEqual(components.query, "someKey=someValue")
        XCTAssertEqual(components.scheme, "http")
    }
}
