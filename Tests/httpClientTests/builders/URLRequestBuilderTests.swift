import Foundation
import httpClient
import XCTest

final class URLRequestBuilderTests: XCTestCase {
    var sut: URLRequestBuilder!
    var someURL: URL!

    override func setUp() {
        super.setUp()
        someURL = URL(string: "http://example.org")
        sut = URLRequestBuilder(url: someURL)
    }

    func testSetMethod() {
        sut.set(httpMethod: .head)
        XCTAssertEqual(sut.build().httpMethod, "HEAD")
        sut.set(httpMethod: .post)
        XCTAssertEqual(sut.build().httpMethod, "POST")
    }

    func testSetCachePolicy() {
        sut.set(cachePolicy: .reloadIgnoringLocalCacheData)
        XCTAssertEqual(sut.build().cachePolicy, .reloadIgnoringLocalCacheData)
        sut.set(cachePolicy: .useProtocolCachePolicy)
        XCTAssertEqual(sut.build().cachePolicy, .useProtocolCachePolicy)
    }

    func testSetTimeoutInterval() {
        sut.set(timeoutInterval: 2)
        XCTAssertEqual(sut.build().timeoutInterval, 2)
        sut.set(timeoutInterval: 4)
        XCTAssertEqual(sut.build().timeoutInterval, 4)
    }

    func testAddHeaderFields() {
        let formUrlEncoded = "application/x-www-form-urlencoded"
        let json = "application/json"
        let text = "plain/text"
        sut.add(httpHeaderFields: [("Content-Type", formUrlEncoded)])
        XCTAssertEqual(sut.build().allHTTPHeaderFields, ["Content-Type": formUrlEncoded])
        sut.add(httpHeaderField: Header(key: "Accept", value: json))
        sut.add(httpHeaderField: Header(key: "Accept", value: text))
        XCTAssertEqual(sut.build().allHTTPHeaderFields, ["Content-Type": formUrlEncoded,
                                                         "Accept": "\(json),\(text)",])
    }

    func testSetHttpBody() {
        let data: Data! = "{\"key\": \"value\"}".data(using: .utf8)
        sut.set(httpBody: data)
        XCTAssertEqual(sut.build().httpBody, data)
    }
}
