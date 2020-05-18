import Foundation

public protocol ExpressibleByArray: ExpressibleByArrayLiteral {
    init(elements: [ArrayLiteralElement])
}

extension ExpressibleByArray {
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(elements: elements)
    }
}
