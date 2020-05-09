import Foundation
import httpClient
import XCTest

final class BodyParametersTests: XCTestCase {
    func testEquatable() {
        let left: BodyParameters = ["a": 0, "b": 0, "c": 0, "d": 0]
        let right: BodyParameters = ["b": 0, "a": 0, "d": 0, "c": 0]
        XCTAssertEqual(left, right)
    }
}
