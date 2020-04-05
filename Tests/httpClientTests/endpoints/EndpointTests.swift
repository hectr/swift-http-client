import Foundation
@testable import httpClient
import XCTest

final class EndpointTests: XCTestCase {
    func testEmptyBodyCurl() {
        struct EmptyBody: Endpoint {
            var baseUrl = "https://example.org"
            var path = "some/path"
            var httpHeaderFields: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          -X GET \\
          -H 'Content-Length: 0' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(EmptyBody().cURL(), expected)
    }

    func testStringBodyCurl() {
        struct StringBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.string(CodableString(string: "some string", encoding: .utf8))
            var httpHeaderFields: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          -X POST \\
          -H 'Content-Type: text/plain; charset=UTF-8' \\
          --data-binary "some string" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(StringBody().cURL(), expected)
    }

    func testDataBodyCurl() {
        struct DataBody: Endpoint {
            var method = HTTPMethod.put
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.data("some data".data(using: .utf8) ?? Data())
            var httpHeaderFields: Headers { Headers([body.contentHeader]) }

        }
        let expected = """
        curl \\
          -X PUT \\
          -H 'Content-Type: application/octet-stream' \\
          --data-binary "some data" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(DataBody().cURL(), expected)
    }

    func testJsonBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.patch
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.json(["some key": "some value"])
            var httpHeaderFields: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          -X PATCH \\
          -H 'Content-Type: application/json; charset=UTF-8' \\
          --data-binary "{\\"some key\\":\\"some value\\"}" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().cURL(), expected)
    }

    func testMultipartformDataBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.multipartformData([MultipartParameter(data: Data(),
                                                                         name: "someName",
                                                                         fileName: "someFilename",
                                                                         mimeType: "some/type")])
            var httpHeaderFields: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          -X POST \\
          -H 'Content-Type: multipart/form-data' \\
          --form name=someName;filename=someFilename;data=@filename;type=some/type \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().cURL(), expected)
    }
}
