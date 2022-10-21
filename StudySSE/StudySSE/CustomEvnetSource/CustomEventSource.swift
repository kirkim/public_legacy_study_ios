//
//  CustomEventSource.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/20.
//

import Foundation

public enum CustomEventSourceState {
    case connecting
    case open
    case closed
}

public protocol CustomEventSourceProtocol {
    var headers: [String: String] { get }

    /// RetryTime: This can be changed remotly if the server sends an event `retry:`
    var retryTime: Int { get }

    /// URL where EventSource will listen for events.
    var url: URL { get }

    /// The last event id received from server. This id is neccesary to keep track of the last event-id received to avoid
    /// receiving duplicate events after a reconnection.
    var lastEventId: String? { get }

    /// Current state of EventSource
    var readyState: CustomEventSourceState { get }

    /// Method used to connect to server. It can receive an optional lastEventId indicating the Last-Event-ID
    ///
    /// - Parameter lastEventId: optional value that is going to be added on the request header to server.
    func connect(lastEventId: String?)

    /// Method used to disconnect from server.
    func disconnect()

    /// Callback called when EventSource has successfully connected to the server.
    ///
    /// - Parameter onOpenCallback: callback
    func onOpen(_ onOpenCallback: @escaping (() -> Void))

    /// Callback called once EventSource has disconnected from server. This can happen for multiple reasons.
    /// The server could have requested the disconnection or maybe a network layer error, wrong URL or any other
    /// error. The callback receives as parameters the status code of the disconnection, if we should reconnect or not
    /// following event source rules and finally the network layer error if any. All this information is more than
    /// enought for you to take a decition if you should reconnect or not.
    /// - Parameter onOpenCallback: callback
    func onComplete(_ onComplete: @escaping ((Int?, Bool?, NSError?) -> Void))
}

open class CustomEventSource: NSObject, CustomEventSourceProtocol, URLSessionDataDelegate {
    
    static let DefaultRetryTime = 3000

    public let url: URL
    private(set) public var lastEventId: String?
    private(set) public var retryTime = CustomEventSource.DefaultRetryTime
    private(set) public var headers: [String: String]
    private(set) public var readyState: CustomEventSourceState

    private var onOpenCallback: (() -> Void)?
    private var onComplete: ((Int?, Bool?, NSError?) -> Void)?

    private var operationQueue: OperationQueue
    private var mainQueue = DispatchQueue.main
    private var urlSession: URLSession?

    public init(
        url: URL,
        headers: [String: String] = [:]
    ) {
        self.url = url
        self.headers = headers

        readyState = CustomEventSourceState.closed
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        super.init()
    }

    public func connect(lastEventId: String? = nil) {
        readyState = .connecting

        let configuration = sessionConfiguration(lastEventId: lastEventId)
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        //TODO: - body 넣기
        var request = URLRequest(url: url)
        let postData = SSEData(imageID: "sample")
        guard let jsonData = try? JSONEncoder().encode(postData) else { return }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.method = .post
        request.httpBody = jsonData
    
        urlSession?.dataTask(with: request).resume()
//        urlSession?.dataTask(with: url).resume()
    }

    public func disconnect() {
        readyState = .closed
        urlSession?.invalidateAndCancel()
    }

    public func onOpen(_ onOpenCallback: @escaping (() -> Void)) {
        self.onOpenCallback = onOpenCallback
    }

    public func onComplete(_ onComplete: @escaping ((Int?, Bool?, NSError?) -> Void)) {
        self.onComplete = onComplete
    }

    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        if readyState != .open {
            return
        }
        print(data)
        let stringValue = String(decoding: data, as: UTF8.self)
        print(stringValue)
    }

    open func urlSession(_ session: URLSession,
                         dataTask: URLSessionDataTask,
                         didReceive response: URLResponse,
                         completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        completionHandler(URLSession.ResponseDisposition.allow)

        readyState = .open
        mainQueue.async { [weak self] in self?.onOpenCallback?() }
    }

    open func urlSession(_ session: URLSession,
                         task: URLSessionTask,
                         didCompleteWithError error: Error?) {

        guard let responseStatusCode = (task.response as? HTTPURLResponse)?.statusCode else {
            mainQueue.async { [weak self] in self?.onComplete?(nil, nil, error as NSError?) }
            return
        }

        let reconnect = shouldReconnect(statusCode: responseStatusCode)
        mainQueue.async { [weak self] in self?.onComplete?(responseStatusCode, reconnect, nil) }
    }

    open func urlSession(_ session: URLSession,
                         task: URLSessionTask,
                         willPerformHTTPRedirection response: HTTPURLResponse,
                         newRequest request: URLRequest,
                         completionHandler: @escaping (URLRequest?) -> Void) {
        var newRequest = request
        self.headers.forEach { newRequest.setValue($1, forHTTPHeaderField: $0) }
        completionHandler(newRequest)
    }
}

internal extension CustomEventSource {

    func sessionConfiguration(lastEventId: String?) -> URLSessionConfiguration {

        var additionalHeaders = headers
        if let eventID = lastEventId {
            additionalHeaders["Last-Event-Id"] = eventID
        }
        additionalHeaders["Content-Type"] = "text/event-stream"
        additionalHeaders["accept"] = "text/event-stream"
        additionalHeaders["Cache-Control"] = "no-cache"
        additionalHeaders["Connection"] = "keep-alive"
//        additionalHeaders["charaterencoder"] = "utf-8"
//        additionalHeaders["Cache-Control"] = "no-cache"

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(INT_MAX)
        sessionConfiguration.timeoutIntervalForResource = TimeInterval(INT_MAX)
        sessionConfiguration.httpAdditionalHeaders = additionalHeaders

        return sessionConfiguration
    }

    func readyStateOpen() {
        readyState = .open
    }
}

private extension CustomEventSource {

    // Following "5 Processing model" from:
    // https://www.w3.org/TR/2009/WD-eventsource-20090421/#handler-eventsource-onerror
    func shouldReconnect(statusCode: Int) -> Bool {
        switch statusCode {
        case 200:
            return false
        case _ where statusCode > 200 && statusCode < 300:
            return true
        default:
            return false
        }
    }
}
