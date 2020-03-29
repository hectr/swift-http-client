import Foundation
import httpClient
import XCTest

final class DataDeserializerTests: XCTestCase {
    var sut: DataDeserializer!

    var someData: Data!

    override func setUp() {
        super.setUp()
        someData = "some data"
        sut = DataDeserializer()
    }

    func test() throws {
        XCTAssertEqual(someData, try sut.deserialize(data: someData))
    }
}
