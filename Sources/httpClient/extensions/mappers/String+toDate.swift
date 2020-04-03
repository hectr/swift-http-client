import Foundation

extension String {
    public func toDate() throws -> Date {
        let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let range = NSRange(startIndex ..< endIndex, in: self)
        var date: Date?
        detector.enumerateMatches(in: self,
                                  options: [],
                                  range: range) { match, _, stop in
            guard let matchedDate = match?.date else {
                return
            }
            date = matchedDate
            stop.pointee = true
        }
        guard let result = date else {
            throw Error.invalidDateString(self)
        }
        return result
    }
}
