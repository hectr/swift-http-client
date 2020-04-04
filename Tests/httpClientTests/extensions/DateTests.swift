import Foundation
import httpClient
import XCTest

final class DateTests: XCTestCase {
    func testExpressibleByString() throws {
        let someDate: Date? = "2020-04-03T15:57:46Z"
        let expectedDate = ISO8601DateFormatter().date(from: "2020-04-03T15:57:46Z")
        XCTAssertEqual(someDate, expectedDate)
        let invalidDate: Date? = "invalid date"
        XCTAssertNil(invalidDate)
    }
}
