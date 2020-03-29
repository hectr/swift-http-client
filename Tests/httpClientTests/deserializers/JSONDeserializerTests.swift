import Foundation
import httpClient
import XCTest

final class JSONDeserializerTests: XCTestCase {
    struct SomeObject: Codable, Equatable {
        let someString: String
    }

    var sut: JSONDeserializer!

    var someData: Data!
    var expectedObject: SomeObject!

    override func setUp() {
        super.setUp()
        expectedObject = SomeObject(someString: "some string")
        someData = try? JSONEncoder().encode(expectedObject)
        sut = JSONDeserializer()
    }

    func test() throws {
        XCTAssertEqual(expectedObject, try sut.deserialize(data: someData))
    }
}
