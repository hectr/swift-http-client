import Foundation
import httpClient
import XCTest

final class FormURLEncodedDeserializerTests: XCTestCase {
    var sut: FormURLEncodedDeserializer!

    var someData: Data!
    var expectedParameters: Parameters!

    override func setUp() {
        super.setUp()
        someData = "some=0&another=many"
        expectedParameters = "some=0&another=many"
        sut = FormURLEncodedDeserializer()
    }

    func test() throws {
        XCTAssertEqual(expectedParameters, try sut.deserialize(data: someData))
    }
}
