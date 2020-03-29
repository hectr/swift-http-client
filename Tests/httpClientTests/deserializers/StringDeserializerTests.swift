import Foundation
import httpClient
import XCTest

final class StringDeserializerTests: XCTestCase {
    var sut: StringDeserializer!

    var someData: Data!
    var expectedString: String!

    override func setUp() {
        super.setUp()
        expectedString = "some string"
    }

    func givenDefaultEncoding() {
        someData = expectedString.data(using: .utf8)
        sut = StringDeserializer()
    }

    func givenAnotherEncoding() {
        someData = expectedString.data(using: .utf16)
        sut = StringDeserializer(encoding: .utf16)
    }

    func test() throws {
        givenDefaultEncoding()
        XCTAssertEqual(expectedString, try sut.deserialize(data: someData))
    }

    func testWithAnotherEncoding() throws {
        givenAnotherEncoding()
        XCTAssertEqual(expectedString, try sut.deserialize(data: someData))
    }
}
