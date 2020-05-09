import Foundation

public struct MultipartParameter: Codable, Equatable {
    public let data: Data
    public let name: String
    public let filename: String?
    public let mimeType: String?

    public init(data: Data, name: String, filename: String? = nil, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
    }
}
