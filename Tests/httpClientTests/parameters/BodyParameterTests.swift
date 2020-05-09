import Foundation
@testable import httpClient
import XCTest

final class BodyParameterTests: XCTestCase {
    func testBoolVisitParameter() {
        XCTAssertEqual(true._visitParameter(), true._visitParameter())
        XCTAssertEqual(false._visitParameter(), false._visitParameter())
        XCTAssertNotEqual(true._visitParameter(), false._visitParameter())
    }

    func testIntVisitParameter() {
        XCTAssertEqual(1._visitParameter(), 1._visitParameter())
        XCTAssertEqual(0._visitParameter(), 0._visitParameter())
        XCTAssertNotEqual((-99)._visitParameter(), 99._visitParameter())
    }

    func testDoubleVisitParameter() {
        XCTAssertEqual(1.0._visitParameter(), 1.0._visitParameter())
        XCTAssertEqual(0.0._visitParameter(), 0.0._visitParameter())
        XCTAssertNotEqual((-99.0)._visitParameter(), 99.0._visitParameter())
    }

    func testStringVisitParameter() {
        XCTAssertEqual(""._visitParameter(), ""._visitParameter())
        XCTAssertEqual("a"._visitParameter(), "a"._visitParameter())
        XCTAssertNotEqual("0"._visitParameter(), "foo"._visitParameter())
    }

    func testArrayVisitParameter() {
        XCTAssertEqual([BodyParameter]()._visitParameter(), [BodyParameter]()._visitParameter())
        XCTAssertEqual([0.0, 1.1]._visitParameter(), [0.0, 1.1]._visitParameter())
        XCTAssertEqual([true, false]._visitParameter(), [true, false]._visitParameter())
        XCTAssertNotEqual(["foo"]._visitParameter(), [["foo"]]._visitParameter())
    }

    func testDictionaryVisitParameter() {
        XCTAssertEqual([String: BodyParameter]()._visitParameter(), [String: BodyParameter]()._visitParameter())
        XCTAssertEqual(["0.0": 0.0, "1.1": 1.1]._visitParameter(), ["0.0": 0.0, "1.1": 1.1]._visitParameter())
        XCTAssertEqual(["true": true, "false": false]._visitParameter(), ["true": true, "false": false]._visitParameter())
        XCTAssertNotEqual(["": "foo"]._visitParameter(), [["foo": ""]]._visitParameter())
    }

    func testOptionalVisitParameter() {
        XCTAssertEqual(BodyParameter?([BodyParameter]())._visitParameter(), [BodyParameter]()._visitParameter())
        XCTAssertEqual(BodyParameter?(1234)._visitParameter(), 1234._visitParameter())
    }

    func testVisitParameter() {
        XCTAssertNotEqual("0"._visitParameter(), 0._visitParameter())
        XCTAssertNotEqual("0.0"._visitParameter(), 0.0._visitParameter())
        XCTAssertNotEqual(0._visitParameter(), 0.0._visitParameter())
        XCTAssertNotEqual([0]._visitParameter(), 0._visitParameter())
        XCTAssertNotEqual(["0": ""]._visitParameter(), 0._visitParameter())
    }
}
