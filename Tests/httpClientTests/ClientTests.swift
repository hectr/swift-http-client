import Foundation
import httpClient
import XCTest

final class ClientTests: XCTestCase {
    var sut: Client!

    var someProvider: NetworkProviderMock!
    var someEndpoint: EndpointMock!
    var someFormUrlEncodedData: Data!
    var someFormUrlEncodedObject: Parameters!

    override func setUp() {
        super.setUp()
        someFormUrlEncodedObject = "a=b&z=1"
        someFormUrlEncodedData = "a=b&z=1"
        someEndpoint = EndpointMock()
        someEndpoint.underlyingResponseDeserializer = FormURLEncodedDeserializer()
        someProvider = NetworkProviderMock()
        someProvider.logger = LoggerMock()
        someProvider.performRequestToCompletionClosure = { _, block in
            block(Result.success(self.someFormUrlEncodedData))
            return OngoingRequestMock()
        }
        sut = Client(provider: someProvider)
    }

    override func tearDown() {
        super.tearDown()
        someProvider.performRequestToCompletionClosure = nil
    }

    func testDeserialize() {
        let expectation = XCTestExpectation()
        var receivedResult: Result<Parameters, Error>?
        sut.performRequest(to: someEndpoint) { (result: Result<Parameters, Error>) -> Void in
            receivedResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        switch receivedResult {
        case .none:
            XCTFail()

        case let .success(parameters):
            XCTAssertEqual(parameters, someFormUrlEncodedObject)

        case .failure:
            XCTFail()
        }
    }

    func testGetLogger() {
        let found = sut.logger as? LoggerMock
        let expected = someProvider.logger as? LoggerMock
        XCTAssertNotNil(found)
        XCTAssertNotNil(expected)
        XCTAssertTrue(found === expected)
    }

    func testSetLogger() {
        let new = LoggerMock()
        let old = sut.logger as? LoggerMock
        XCTAssertFalse(new === old)
        sut.logger = new
        let found = sut.logger as? LoggerMock
        let expected = someProvider.logger as? LoggerMock
        XCTAssertNotNil(found)
        XCTAssertNotNil(expected)
        XCTAssertTrue(found === expected)
    }
}
