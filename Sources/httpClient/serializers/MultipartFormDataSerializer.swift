import Foundation

public struct MultipartFormDataSerializer: BodySerializer, Codable, Equatable {
    private let parameters: MultipartParameters
    private let boundary: String

    public init(_ parameters: MultipartParameters, boundary: String? = nil) {
        self.parameters = parameters
        if let boundary = boundary {
            self.boundary = boundary
        } else {
            self.boundary = "httpClient.boundary.\(UUID().uuidString)"
        }
    }

    public func contentHeaders() -> Headers {
        [("Content-Type", "multipart/form-data")]
    }

    public func contentData() throws -> Data {
        var data = Data()
        for (index, parameter) in parameters.enumerated() {
            let part = try parameter.toData(boundary: boundary, isEncapsulation: index == 0)
            data.append(part)
        }
        try addFinalBoundary(to: &data)
        return data
    }

    public func toCurlBody() -> [String] {
        parameters.map { buildFormParameter(from: $0) }
    }

    private func buildFormParameter(from multipartParameter: MultipartParameter) -> String {
        var components = [String]()
        if !multipartParameter.name.isEmpty {
            components.append("name=\(multipartParameter.name)")
        }
        if let filename = multipartParameter.filename, !filename.isEmpty {
            components.append("filename=\(filename)")
        }
        components.append("data=@filename")
        if let mimeType = multipartParameter.mimeType, !mimeType.isEmpty {
            components.append("type=\(mimeType)")
        }
        return "--form '\(components.joined(separator: ";"))'"
    }

    private func addFinalBoundary(to data: inout Data) throws {
        let dashes = try "--".toData()
        let crlf = try "\r\n".toData()
        data.append(crlf)
        data.append(dashes)
        data.append(try boundary.toData())
        data.append(dashes)
        data.append(crlf)
    }
}
