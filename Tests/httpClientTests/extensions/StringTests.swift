import Foundation
@testable import httpClient
import XCTest

final class StringTests: XCTestCase {
    func testToData() throws {
        XCTAssertEqual(try "some string".toData(), "some string".data(using: .utf8))
        XCTAssertEqual(try "some string".toData(encoding: .utf16), "some string".data(using: .utf16))
    }

    func testToDate() throws {
        let someDateString = "2020-04-03T15:57:46Z"
        let expectedDate = ISO8601DateFormatter().date(from: someDateString)
        let date = try? someDateString.toDate()
        XCTAssertEqual(date, expectedDate)
        XCTAssertThrowsError(try "invalid date".toDate())
    }

    func testToEscapedString() throws {
        XCTAssertEqual("$\\`sóme\nstrïng`\\$".toEscapedString(), "\\$\\\\\\`sóme\nstrïng\\`\\\\\\$")
    }

    func testToInt() throws {
        let expectedInt = 123
        let someIntString = "\(expectedInt)"
        let integer = try someIntString.toInt()
        XCTAssertEqual(integer, expectedInt)
        XCTAssertThrowsError(try "123.45".toInt())
    }

    func testToDouble() throws {
        let expectedDouble = 123.45
        let someDoubleString = "\(expectedDouble)"
        let double = try someDoubleString.toDouble()
        XCTAssertEqual(double, expectedDouble)
        XCTAssertThrowsError(try "123.45.67".toDouble())
    }

    func testToURL() throws {
        let someUrlString = "http://example.org/"
        let url = try someUrlString.toURL()
        XCTAssertEqual(url.absoluteString, someUrlString)
        XCTAssertThrowsError(try "invalid url".toURL())
    }

    func testToURLQueryItem() throws {
        let someQueryString = "aa=bb"
        let queryItem = try someQueryString.toURLQueryItem()
        XCTAssertEqual(queryItem.name, someQueryString.components(separatedBy: "=").first)
        XCTAssertEqual(queryItem.value, someQueryString.components(separatedBy: "=").last)
    }
}
