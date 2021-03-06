import Foundation

public struct Parameters: Equatable {
    public typealias Iterator = Array<Parameter>.Iterator

    private let parameters: [Parameter]

    public var isEmpty: Bool {
        parameters.isEmpty
    }

    public init(_ parameters: [Parameter]) {
        self.parameters = parameters
    }

    public init(elements: [(String, String)]) {
        let parameters = elements.map { Parameter(key: $0.0, value: $0.1) }
        self = Parameters(parameters)
    }

    public func appending(_ parameter: Parameter) -> Self {
        Self(parameters + [parameter])
    }

    public func toURLComponents() -> URLComponents {
        var components = URLComponents()
        components.queryItems = parameters.map { $0.toURLQueryItem() }
        return components
    }
}

// MARK: - Codable

extension Parameters: Codable {
    public init(from decoder: Decoder) throws {
        let decodedString = try String(from: decoder)
        let queryItems = try decodedString.toURLQueryItems()
        let parameters = queryItems.map { $0.toParameter() }
        self = Parameters(parameters)
    }

    public func encode(to encoder: Encoder) throws {
        try toURLComponents()
            .percentEncodedQuery
            .encode(to: encoder)
    }
}

// MARK: - ExpressibleByArray

extension Parameters: ExpressibleByArray {
    public typealias ArrayLiteralElement = (String, String)
}

// MARK: - ExpressibleByDictionary

extension Parameters: ExpressibleByDictionary {
    public typealias Key = String
    public typealias Value = String
    public init(dictionaryElements: [(Key, Value)]) {
        self = Parameters(elements: dictionaryElements)
    }
}

// MARK: - Sequence

extension Parameters: Sequence {
    public func makeIterator() -> Iterator {
        parameters.makeIterator()
    }
}
