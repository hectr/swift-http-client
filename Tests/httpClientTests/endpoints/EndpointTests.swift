import Foundation
@testable import httpClient
import XCTest

final class EndpointTests: XCTestCase {
    func testCurlVerbose() {
        struct SomeEndpoint: Endpoint {
            var baseUrl = "https://example.org"
            var path = "some/path"
        }
        let expected = """
        curl --verbose \\
          --request GET \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(SomeEndpoint().cURL(), expected)
    }

    func testEmptyBodyCurl() {
        struct EmptyBody: Endpoint {
            var baseUrl = "https://example.org"
            var path = "some/path"
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request GET \\
          --header 'Content-Length: 0' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(EmptyBody().cURL(verbose: false), expected)
    }

    func testStringBodyCurl() {
        struct StringBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.string(CodableString(string: "some string", encoding: .utf8))
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: text/plain; charset=UTF-8' \\
          --data-binary "some string" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(StringBody().cURL(verbose: false), expected)
    }

    func testDataBodyCurl() {
        struct DataBody: Endpoint {
            var method = HTTPMethod.put
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.data("some data".data(using: .utf8) ?? Data())
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request PUT \\
          --header 'Content-Type: application/octet-stream' \\
          --data-binary "some data" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(DataBody().cURL(verbose: false), expected)
    }

    func testJsonBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.patch
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.json(["some key": "some value"])
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request PATCH \\
          --header 'Content-Type: application/json; charset=UTF-8' \\
          --data-binary "{\\"some key\\":\\"some value\\"}" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().cURL(verbose: false), expected)
    }

    func testFormUrlEncodedBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.patch
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.formUrlEncoded(["some key": "some value"])
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request PATCH \\
          --header 'Content-Type: application/x-www-form-urlencoded' \\
          --data-urlencode "some%20key=some%20value" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().cURL(verbose: false), expected)
    }

    func testMultipartformDataBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.multipartFormData([MultipartParameter(data: Data(),
                                                                  name: "someName",
                                                                  fileName: "someFilename",
                                                                  mimeType: "some/type")])
            var headers: Headers { Headers([body.contentHeader]) }
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: multipart/form-data' \\
          --form 'name=someName;filename=someFilename;data=@filename;type=some/type' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().cURL(verbose: false), expected)
    }
}
