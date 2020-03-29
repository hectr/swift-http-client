import Foundation

public protocol Logger {
    func log(endpoint: Endpoint)
    func log(endpoint: Endpoint?, error: Error)
    func log(request: URLRequest)
    func log(request: URLRequest?, error: Error)
    func log(response: HTTPURLResponse?, data: Data)
    func log(response: HTTPURLResponse?, error: Error)
    func log(data: Data?, error: Error)
}
