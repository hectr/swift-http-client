import Foundation
import httpClient
import XCTest

final class MultipartParameterTests: XCTestCase {
    var someData: Data!
    var someName: String!
    var someFilename: String!
    var someMimeType: String!

    override func setUp() {
        super.setUp()
        someData = "some data"
        someName = "some name"
        someFilename = "some filename"
        someMimeType = "some/mime"
    }

    func testInit() throws {
        let sut = MultipartParameter(data: someData,
                                     name: someName,
                                     filename: someFilename,
                                     mimeType: someMimeType)
        XCTAssertEqual(someData, sut.data)
        XCTAssertEqual(someName, sut.name)
        XCTAssertEqual(someFilename, sut.filename)
        XCTAssertEqual(someMimeType, sut.mimeType)
    }
}
