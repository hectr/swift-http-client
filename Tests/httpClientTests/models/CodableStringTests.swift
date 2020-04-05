import Foundation
import httpClient
import XCTest

final class CodableStringTests: XCTestCase {
    func testExpressibleByStringLiteral() {
        let codableString: CodableString = "some string"
        XCTAssertEqual(codableString.string, "some string")
        XCTAssertEqual(codableString.encoding, .utf8)
    }

    func testToData() throws {
        let codableString = CodableString(string: "some string", encoding: .utf16)
        let expected = "some string".data(using: .utf16)
        XCTAssertEqual(try codableString.toData(), expected)
    }
}
