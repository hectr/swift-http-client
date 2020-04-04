import Foundation

public struct MultipartParameter: Equatable, Codable {
    public let data: Data
    public let name: String
    public let fileName: String
    public let mimeType: String

    public init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
