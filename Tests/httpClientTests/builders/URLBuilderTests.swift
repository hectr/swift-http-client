import Foundation
import httpClient
import XCTest

final class URLBuilderTests: XCTestCase {
    var sut: URLBuilder!

    override func setUp() {
        super.setUp()
        sut = try? URLBuilder(baseUrl: "http://example.org")
    }

    func testInitWithBaseUrl() {
        XCTAssertNoThrow(try URLBuilder(baseUrl: "http://example.org"))
        XCTAssertThrowsError(try URLBuilder(baseUrl: "wrong url"))
    }

    func testAddPath() throws {
        try sut.add(path: "path")
        try sut.add(path: "component")
        XCTAssertEqual(try sut.build().absoluteString, "http://example.org/path/component")
    }

    func testAddParameters() {
        sut.add(parameters: ["param": "0"])
        XCTAssertNoThrow(try sut.build())
    }

    func testAddParametersWithoutReplacingDuplicates() throws {
        let someParameter: Parameter! = "param=0"
        sut.add(parameter: someParameter)
        sut.add(parameter: someParameter)
        XCTAssertEqual(try sut.build().absoluteString, "http://example.org?param=0&param=0")
    }

    func testUrlEncodingOfParameters() throws {
        try sut.add(path: "path")
        sut.add(parameters: [("param", "some \"parámetro\"")])
        XCTAssertEqual(try? sut.build().absoluteString, "http://example.org/path?param=some%20%22par%C3%A1metro%22")
    }

    func testParametersQuestionMark() {
        sut.add(parameters: nil)
        XCTAssertEqual(try? sut.build().absoluteString, "http://example.org")
        sut.add(parameters: [])
        XCTAssertEqual(try? sut.build().absoluteString, "http://example.org?")
    }
}
