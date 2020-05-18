import Foundation

public protocol ExpressibleByDictionary: ExpressibleByDictionaryLiteral {
    init(dictionaryElements: [(Key, Value)])
}

extension ExpressibleByDictionary {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(dictionaryElements: elements)
    }
}
