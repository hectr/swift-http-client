import Foundation
import httpClient
import XCTest

final class BodyTests: XCTestCase {
    func testEmpty() {
        XCTAssertTrue(Body.empty.isEmpty)
        XCTAssertFalse(Body.string("foo").isEmpty)
        XCTAssertFalse(Body.data(Data()).isEmpty)
        XCTAssertFalse(Body.json([]).isEmpty)
        XCTAssertFalse(Body.formUrlEncoded([]).isEmpty)
        XCTAssertFalse(Body.multipartFormData([]).isEmpty)
    }

    func testString() {
        XCTAssertFalse(Body.empty.isString)
        XCTAssertTrue(Body.string("foo").isString)
        XCTAssertFalse(Body.data(Data()).isString)
        XCTAssertFalse(Body.json([]).isString)
        XCTAssertFalse(Body.formUrlEncoded([]).isString)
        XCTAssertFalse(Body.multipartFormData([]).isString)
    }

    func testData() {
        XCTAssertFalse(Body.empty.isData)
        XCTAssertFalse(Body.string("foo").isData)
        XCTAssertTrue(Body.data(Data()).isData)
        XCTAssertFalse(Body.json([]).isData)
        XCTAssertFalse(Body.formUrlEncoded([]).isData)
        XCTAssertFalse(Body.multipartFormData([]).isData)
    }

    func testJson() {
        XCTAssertFalse(Body.empty.isJson)
        XCTAssertFalse(Body.string("foo").isJson)
        XCTAssertFalse(Body.data(Data()).isJson)
        XCTAssertTrue(Body.json([]).isJson)
        XCTAssertFalse(Body.formUrlEncoded([]).isJson)
        XCTAssertFalse(Body.multipartFormData([]).isJson)
    }

    func testFormUrlEncoded() {
        XCTAssertFalse(Body.empty.isFormUrlEncoded)
        XCTAssertFalse(Body.string("foo").isFormUrlEncoded)
        XCTAssertFalse(Body.data(Data()).isFormUrlEncoded)
        XCTAssertFalse(Body.json([]).isFormUrlEncoded)
        XCTAssertTrue(Body.formUrlEncoded([]).isFormUrlEncoded)
        XCTAssertFalse(Body.multipartFormData([]).isFormUrlEncoded)
    }

    func test() {
        XCTAssertFalse(Body.empty.isMultipartFormData)
        XCTAssertFalse(Body.string("foo").isMultipartFormData)
        XCTAssertFalse(Body.data(Data()).isMultipartFormData)
        XCTAssertFalse(Body.json([]).isMultipartFormData)
        XCTAssertFalse(Body.formUrlEncoded([]).isMultipartFormData)
        XCTAssertTrue(Body.multipartFormData([]).isMultipartFormData)
    }
}
