import Foundation
import httpClient
import XCTest

final class AnyLoggerTests: XCTestCase {
    var sut: AnyLogger!

    var someURL: URL!
    var someRequest: URLRequest!
    var someResponse: HTTPURLResponse!
    var someData: Data!
    var someError: Error!

    var receivedData: Data?
    var receivedEndpoint: Endpoint?
    var receivedError: Error?
    var receivedResponse: HTTPURLResponse?
    var receivedRequest: URLRequest?

    override func setUp() {
        super.setUp()
        someURL = "some.url"
        someRequest = URLRequest(url: someURL)
        someResponse = HTTPURLResponse()
        someData = Data()
        someError = .invalidUrlString("ínvàlïd ūrl")
        sut = AnyLogger(logEndpoint: { self.receivedEndpoint = $0 },
                        logEndpointError: { self.receivedEndpoint = $0; self.receivedError = $1 },
                        logRequest: { self.receivedRequest = $0 },
                        logRequestError: { self.receivedRequest = $0; self.receivedError = $1 },
                        logResponseData: { self.receivedResponse = $0; self.receivedData = $1 },
                        logResponseError: { self.receivedResponse = $0; self.receivedError = $1 },
                        logDataError: { self.receivedData = $0; self.receivedError = $1 })
    }

    override func tearDown() {
        super.tearDown()
        receivedData = nil
        receivedEndpoint = nil
        receivedError = nil
        receivedResponse = nil
        receivedRequest = nil
    }

    func testLogEndpoint() throws {
        sut.log(endpoint: EndpointMock())
        XCTAssertNotNil(receivedEndpoint)
    }

    func testLogEndpointError() throws {
        sut.log(endpoint: EndpointMock(),
                error: someError)
        XCTAssertNotNil(receivedEndpoint)
        XCTAssertNotNil(receivedError)
    }

    func testLogRequest() throws {
        sut.log(request: someRequest)
        XCTAssertNotNil(receivedRequest)
    }

    func testLogRequestError() throws {
        sut.log(request: someRequest,
                error: someError)
        XCTAssertNotNil(receivedRequest)
        XCTAssertNotNil(receivedError)
    }

    func testLogResponseData() throws {
        sut.log(response: someResponse,
                data: someData)
        XCTAssertNotNil(receivedResponse)
        XCTAssertNotNil(receivedData)
    }

    func testLogResponseError() throws {
        sut.log(response: someResponse,
                error: someError)
        XCTAssertNotNil(receivedResponse)
        XCTAssertNotNil(receivedError)
    }

    func testLogDataError() throws {
        sut.log(data: someData,
                error: someError)
        XCTAssertNotNil(receivedData)
        XCTAssertNotNil(receivedError)
    }
}
