import Foundation

public struct MultipartFormDataSerializer: BodySerializer, Codable, Equatable {
    private let parameters: MultipartParameters

    public init(_ parameters: MultipartParameters) {
        self.parameters = parameters
    }

    public func contentHeaders() -> Headers {
        [("Content-Type", "multipart/form-data")]
    }

    public func contentData() throws -> Data {
        throw NSError(domain: #function, code: #line, userInfo: [NSLocalizedDescriptionKey: "Not implemented yet"]) // TODO: @hectr implement
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
}
