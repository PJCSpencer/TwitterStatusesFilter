//
//  PJCDataStreamService.swift
//  TweetMap
//
//  Created by Peter Spencer on 07/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCDataStreamServiceResult = Result<Data, Error>

typealias PJCDataStreamServiceResponseHandler = (_ result: Data) -> Void

class PJCDataStreamService: NSObject
{
    // MARK: - Property(s)
    
    fileprivate lazy var session: URLSession =
    {
        let configuration = URLSessionConfiguration.named("com.tweet-core.cache.stream") // TODO:Support injection ...
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue: nil)
        
        return session
    }()
    
    fileprivate var task: URLSessionDataTask?
    {
        didSet
        {
            oldValue?.cancel()
            task?.resume()
        }
    }
    
    fileprivate var responseHandler: PJCDataStreamServiceResponseHandler?
}

extension PJCDataStreamService
{
    func connect(with request: URLRequest,
                 responseHandler: PJCDataStreamServiceResponseHandler?)
    {
        self.responseHandler = responseHandler
        self.task = self.session.dataTask(with: request)
    }
    
    func disconnect()
    { self.task = nil }
}

extension PJCDataStreamService: URLSessionDataDelegate
{
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        completionHandler(dataTask.state != .canceling ? .allow : .cancel)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data)
    {
        self.responseHandler?(data)
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?)
    {
        self.disconnect()
    }
}

