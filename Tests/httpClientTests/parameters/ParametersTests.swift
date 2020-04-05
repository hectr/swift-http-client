import Foundation
import httpClient
import XCTest

final class ParametersTests: XCTestCase {
    func testIsEmpty() throws {
        let empty = Parameters(elements: [])
        XCTAssertTrue(empty.isEmpty)
        let nonEmpty = Parameters(elements: [("a", "a")])
        XCTAssertFalse(nonEmpty.isEmpty)
    }
}
