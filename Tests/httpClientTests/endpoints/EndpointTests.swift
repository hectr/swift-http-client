import Foundation
@testable import httpClient
import XCTest

final class EndpointTests: XCTestCase {
    static var nonUtf8Data: Data = {
        let bytes: [UInt32] = [128]
        return Data(bytes: bytes, count: bytes.count * MemoryLayout<UInt32>.stride)
    }()

    func testCurlVerbose() {
        struct SomeEndpoint: Endpoint {
            var baseUrl = "https://example.org"
            var path = "some/path"
            var headers: Headers { [] }
        }
        let expected = """
        curl --verbose \\
          --request GET \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(SomeEndpoint().toCurl(), expected)
    }

    func testEmptyBodyCurl() {
        struct EmptyBody: Endpoint {
            var baseUrl = "https://example.org"
            var path = "some/path"
        }
        let expected = """
        curl \\
          --request GET \\
          --header 'Content-Length: 0' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(EmptyBody().toCurl(verbose: false), expected)
    }

    func testStringBodyCurl() {
        struct StringBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.string(CodableString(string: "some string", encoding: .utf8))
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: text/plain; charset=UTF-8' \\
          --data-binary "some string" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(StringBody().toCurl(verbose: false), expected)
    }

    func testDataBodyCurl() {
        struct DataBody: Endpoint {
            var method = HTTPMethod.put
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.data("some data".data(using: .utf8) ?? Data())
        }
        let expected = """
        curl \\
          --request PUT \\
          --header 'Content-Type: application/octet-stream' \\
          --data-binary "some data" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(DataBody().toCurl(verbose: false), expected)
    }

    func testJsonBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.patch
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.json(["some key": "some value"])
        }
        let expected = """
        curl \\
          --request PATCH \\
          --header 'Content-Type: application/json; charset=UTF-8' \\
          --data-binary "{\\"some key\\":\\"some value\\"}" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().toCurl(verbose: false), expected)
    }

    func testFormUrlEncodedBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.patch
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.formUrlEncoded(["some key": "some value"])
        }
        let expected = """
        curl \\
          --request PATCH \\
          --header 'Content-Type: application/x-www-form-urlencoded' \\
          --data-urlencode "some%20key=some%20value" \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().toCurl(verbose: false), expected)
    }

    func testMultipartformDataBodyCurl() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.multipartFormData([MultipartParameter(data: EndpointTests.nonUtf8Data,
                                                                  name: "someName",
                                                                  filename: "someFilename",
                                                                  mimeType: "some/type"),])
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: multipart/form-data' \\
          --form 'name=someName;filename=someFilename;data=@filename;type=some/type' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().toCurl(verbose: false), expected)
    }

    func testMultipartformDataBodyCurlWithoutFilename() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.multipartFormData([MultipartParameter(data: EndpointTests.nonUtf8Data,
                                                                  name: "someName",
                                                                  filename: nil,
                                                                  mimeType: "some/type"),])
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: multipart/form-data' \\
          --form 'name=someName;data=@filename;type=some/type' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().toCurl(verbose: false), expected)
    }

    func testMultipartformDataBodyCurlWithoutMimeType() {
        struct JsonBody: Endpoint {
            var method = HTTPMethod.post
            var baseUrl = "https://example.org"
            var path = "some/path"
            var body = Body.multipartFormData([MultipartParameter(data: EndpointTests.nonUtf8Data,
                                                                  name: "someName",
                                                                  filename: "someFilename",
                                                                  mimeType: nil),])
        }
        let expected = """
        curl \\
          --request POST \\
          --header 'Content-Type: multipart/form-data' \\
          --form 'name=someName;filename=someFilename;data=@filename' \\
          "https://example.org/some/path"
        """
        XCTAssertEqual(JsonBody().toCurl(verbose: false), expected)
    }
}
