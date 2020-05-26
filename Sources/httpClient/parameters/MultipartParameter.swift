import Foundation

public struct MultipartParameter: Codable, Equatable {
    public let data: Data
    public let name: String
    public let filename: String?
    public let mimeType: String?

    public var contentDisposition: String {
        var contentDisposition = "Content-Disposition: form-data; name=\"\(name)\""
        if let filename = filename {
            contentDisposition.append("; filename=\"\(filename)\"")
        }
        return contentDisposition
    }

    public var contentType: String? {
        guard let mimeType = mimeType else {
            return nil
        }
        return "Content-Type: \(mimeType)"
    }

    public init(data: Data, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }

    public init(value: String, name: String) throws {
        self.data = try value.toData()
        self.name = name
        self.filename = nil
        self.mimeType = nil
    }

    public func toData(boundary: String, isEncapsulation: Bool) throws -> Data {
        var part = Data()
        try addBoundary(boundary, to: &part, isEncapsulation: isEncapsulation)
        try addContentDisposition(to: &part)
        try addData(to: &part)
        return part
    }

    private func addBoundary(_ boundary: String, to part: inout Data, isEncapsulation: Bool) throws {
        let dashes = try "--".toData()
        let crlf = try "\r\n".toData()
        if isEncapsulation {
            part.append(crlf)
        }
        part.append(dashes)
        part.append(try boundary.toData())
        part.append(crlf)
    }

    private func addContentDisposition(to part: inout Data) throws {
        let crlf = try "\r\n".toData()
        part.append(try contentDisposition.toData())
        part.append(crlf)
    }

    private func addContentType(to part: inout Data) throws {
        if let contentType = contentType {
            let crlf = try "\r\n".toData()
            part.append(try contentType.toData())
            part.append(crlf)
        }
    }

    private func addData(to part: inout Data) throws {
        let crlf = try "\r\n".toData()
        part.append(crlf)
        part.append(data)
        part.append(crlf)
    }
}
