import Foundation
import httpClient
import XCTest

final class MockingNetworkProviderShould: XCTestCase {
    var sut: MockingNetworkProvider!

    var someEndpoint: MutableEndpoint<StringDeserializer>!
    var someHeaders: Headers!
    var someHttpMethod: HTTPMethod!
    var someBaseUrl: String!
    var somePath: String!
    var someParameters: Parameters!
    var someBody: Body!
    var someTimeoutInterval: TimeInterval!
    var someCachePolicy: URLRequest.CachePolicy!
    var someDeserializer: StringDeserializer!
    var someData: Data!
    var someResponseBody: Body?
    var someLogger: LoggerMock!

    override func setUp() {
        super.setUp()
        someHeaders = ["name": "value"]
        someHttpMethod = "TRACE"
        someBaseUrl = "http://example.org"
        somePath = "path"
        someParameters = [("key", "value")]
        someBody = .empty
        someData = "some data"
        someCachePolicy = .useProtocolCachePolicy
        someTimeoutInterval = 20
        someDeserializer = StringDeserializer()
        someLogger = LoggerMock()
        sut = MockingNetworkProvider(logger: someLogger)
    }

    func givenHasResponseBodyExample() {
        someResponseBody = .data(someData)
        buildEndpoint()
    }

    func givenHasNotResponseBodyExample() {
        someResponseBody = nil
        buildEndpoint()
    }

    func buildEndpoint() {
        someEndpoint = MutableEndpoint<StringDeserializer>(
            method: someHttpMethod,
            baseUrl: someBaseUrl,
            path: somePath,
            queryParameters: someParameters,
            body: someBody,
            cachePolicy: someCachePolicy,
            timeoutInterval: someTimeoutInterval,
            httpHeaderFields: someHeaders,
            concreteDeserializer: StringDeserializer(),
            responseBodyExample: someResponseBody
        )
    }

    func testSuccess() {
        givenHasResponseBodyExample()
        let expectation = XCTestExpectation()
        _ = sut.performRequest(to: someEndpoint) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(self.someResponseBody, .data(data))

            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        XCTAssertTrue(someLogger.logEndpointCalled)
        XCTAssertFalse(someLogger.logEndpointErrorCalled)
        XCTAssertTrue(someLogger.logRequestCalled)
        XCTAssertFalse(someLogger.logRequestErrorCalled)
        XCTAssertTrue(someLogger.logResponseDataCalled)
        XCTAssertFalse(someLogger.logResponseErrorCalled)
        XCTAssertFalse(someLogger.logDataErrorCalled)
    }

    func testFailure() {
        givenHasNotResponseBodyExample()
        let expectation = XCTestExpectation()
        _ = sut.performRequest(to: someEndpoint) { result in
            switch result {
            case .success:
                XCTFail()

            case .failure:
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        XCTAssertTrue(someLogger.logEndpointCalled)
        XCTAssertFalse(someLogger.logEndpointErrorCalled)
        XCTAssertTrue(someLogger.logRequestCalled)
        XCTAssertTrue(someLogger.logRequestErrorCalled)
        XCTAssertFalse(someLogger.logResponseDataCalled)
        XCTAssertFalse(someLogger.logResponseErrorCalled)
        XCTAssertFalse(someLogger.logDataErrorCalled)
    }
}
