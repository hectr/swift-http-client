import Foundation
import httpClient
import XCTest

final class URLTests: XCTestCase {
    func testToURLComponents() throws {
        let someURL: URL! = "http://example.org/some/path?someKey=someValue"
        let components = try someURL.toURLComponents()
        XCTAssertEqual(components.host, "example.org")
        XCTAssertEqual(components.path, "/some/path")
        XCTAssertEqual(components.query, "someKey=someValue")
        XCTAssertEqual(components.scheme, "http")
    }
}
