import Foundation
@testable import httpClient
import XCTest

final class InternalEndpointTests: XCTestCase {
    var someEndpoint: Endpoint!
    var anotherEndpoint: Endpoint!
    var someHeaders: Headers!
    var anotherHeaders: Headers!
    var someHttpMethod: HTTPMethod!
    var anotherHttpMethod: HTTPMethod!
    var someBaseUrl: String!
    var anotherBaseUrl: String!
    var somePathComponent: String!
    var somePath: String!
    var anotherPath: String!
    var someParameter: Parameter!
    var someParameters: Parameters!
    var anotherParameters: Parameters!
    var someBody: Body!
    var anotherBody: Body!
    var someTimeoutInterval: TimeInterval!
    var anotherTimeoutInterval: TimeInterval!
    var someCachePolicy: URLRequest.CachePolicy!
    var anotherCachePolicy: URLRequest.CachePolicy!
    var someDeserializer: Deserializer!
    var anotherDeserializer: Deserializer!
    var someData: Data!
    var anotherData: Data!

    override func setUp() {
        super.setUp()
        someHeaders = ["some name": "some value"]
        anotherHeaders = ["another name": "another value"]
        someHttpMethod = "PUT"
        anotherHttpMethod = "POST"
        someBaseUrl = "https://example.org"
        anotherBaseUrl = "http://example.net"
        somePathComponent = "copmonent"
        somePath = "some/path"
        anotherPath = "another/path"
        someParameter = Parameter(key: "key", value: "value")
        someParameters = [("some key", "some value")]
        anotherParameters = [("another key", "another value")]
        someBody = "some body"
        anotherBody = "another body"
        someCachePolicy = .returnCacheDataElseLoad
        anotherCachePolicy = .reloadIgnoringLocalCacheData
        someTimeoutInterval = 10
        anotherTimeoutInterval = 30
        someDeserializer = StringDeserializer()
        anotherDeserializer = DataDeserializer()
        someData = "some data"
        anotherData = "another data"
        someEndpoint = _Endpoint(method: someHttpMethod,
                                 baseUrl: someBaseUrl,
                                 path: somePath,
                                 queryParameters: someParameters,
                                 body: someBody,
                                 cachePolicy: someCachePolicy,
                                 timeoutInterval: someTimeoutInterval,
                                 headers: someHeaders,
                                 responseDeserializer: StringDeserializer(),
                                 responseBodyExample: .data(someData))
    }

    func testEndpointAddinggMethods() {
        let anotherEndpoint = someEndpoint
            .updatingQueryParameters(to: [])
            .updatingHeaders(to: [])
            .addingPathComponent(somePathComponent)
            .addingQueryParameter(someParameter)
            .addingHeader(someParameter)
        XCTAssertEqual(anotherEndpoint.method, someHttpMethod)
        XCTAssertEqual(anotherEndpoint.baseUrl, someBaseUrl)
        XCTAssertEqual(anotherEndpoint.path, somePath + "/" + somePathComponent)
        XCTAssertEqual(anotherEndpoint.queryParameters, Parameters([someParameter]))
        XCTAssertEqual(anotherEndpoint.body, someBody)
        XCTAssertEqual(anotherEndpoint.cachePolicy, someCachePolicy)
        XCTAssertEqual(anotherEndpoint.timeoutInterval, someTimeoutInterval)
        XCTAssertEqual(anotherEndpoint.headers, Headers([someParameter]))
        XCTAssertTrue(anotherEndpoint.responseDeserializer is StringDeserializer)
        XCTAssertEqual(anotherEndpoint.responseBodyExample, .data(someData))
    }

    func testEndpointUpdatingMethods() {
        let anotherEndpoint = someEndpoint
            .updatingMethod(to: anotherHttpMethod)
            .updatingBaseUrl(to: anotherBaseUrl)
            .updatingPath(to: anotherPath)
            .updatingQueryParameters(to: anotherParameters)
            .updatingBody(to: anotherBody)
            .updatingCachePolicy(to: anotherCachePolicy)
            .updatingTimeoutInterval(to: anotherTimeoutInterval)
            .updatingHeaders(to: anotherHeaders)
            .updatingResponseDeserializer(to: anotherDeserializer)
            .updatingResponseBodyExample(to: .data(anotherData))
        XCTAssertEqual(anotherEndpoint.method, anotherHttpMethod)
        XCTAssertEqual(anotherEndpoint.baseUrl, anotherBaseUrl)
        XCTAssertEqual(anotherEndpoint.path, anotherPath)
        XCTAssertEqual(anotherEndpoint.queryParameters, anotherParameters)
        XCTAssertEqual(anotherEndpoint.body, anotherBody)
        XCTAssertEqual(anotherEndpoint.cachePolicy, anotherCachePolicy)
        XCTAssertEqual(anotherEndpoint.timeoutInterval, anotherTimeoutInterval)
        XCTAssertEqual(anotherEndpoint.headers, anotherHeaders)
        XCTAssertTrue(anotherEndpoint.responseDeserializer is DataDeserializer)
        XCTAssertEqual(anotherEndpoint.responseBodyExample, .data(anotherData))
    }

    func testInitInternalEndpointWithEndpoint() {
        let equivalent = _Endpoint(someEndpoint)
        XCTAssertEqual(equivalent.method, someHttpMethod)
        XCTAssertEqual(equivalent.baseUrl, someBaseUrl)
        XCTAssertEqual(equivalent.path, somePath)
        XCTAssertEqual(equivalent.queryParameters, someParameters)
        XCTAssertEqual(equivalent.body, someBody)
        XCTAssertEqual(equivalent.cachePolicy, someCachePolicy)
        XCTAssertEqual(equivalent.timeoutInterval, someTimeoutInterval)
        XCTAssertEqual(equivalent.headers, someHeaders)
        XCTAssertTrue(equivalent.responseDeserializer is StringDeserializer)
        XCTAssertEqual(equivalent.responseBodyExample, .data(someData))
    }
}
