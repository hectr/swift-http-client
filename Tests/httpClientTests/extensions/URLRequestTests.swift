import Foundation
import httpClient
import XCTest

final class URLRequestTests: XCTestCase {
    var someEndpoint: EndpointMock!
    var someHeaders: Headers!
    var someHttpMethod: HTTPMethod!
    var someBaseUrl: String!
    var somePath: String!
    var someParameters: Parameters!
    var someTimeoutInterval: TimeInterval!
    var someCachePolicy: URLRequest.CachePolicy!

    override func setUp() {
        super.setUp()
        someHeaders = ["name": "value"]
        someHttpMethod = "TRACE"
        someBaseUrl = "http://example.org"
        somePath = "path"
        someParameters = [("key", "value")]
        someCachePolicy = .useProtocolCachePolicy
        someTimeoutInterval = 20
        someEndpoint = EndpointMock()
        someEndpoint.headers = someHeaders
        someEndpoint.method = someHttpMethod
        someEndpoint.baseUrl = someBaseUrl
        someEndpoint.path = somePath
        someEndpoint.queryParameters = someParameters
        someEndpoint.cachePolicy = someCachePolicy
        someEndpoint.timeoutInterval = someTimeoutInterval
    }

    func testBuild() throws {
        let request = try URLRequest.build(with: someEndpoint)
        XCTAssertEqual(request.allHTTPHeaderFields, someHeaders.toHeaderFields())
        XCTAssertEqual(request.url?.absoluteString, "http://example.org/path?key=value")
        XCTAssertEqual(request.httpMethod, someHttpMethod.rawValue)
        XCTAssertEqual(request.timeoutInterval, someTimeoutInterval)
        XCTAssertEqual(request.cachePolicy, someCachePolicy)
    }
}
