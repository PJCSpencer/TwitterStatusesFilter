//
//  PJCTweetStatusesFilter.swift
//  TweetMap
//
//  Created by Peter Spencer on 08/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


public typealias PJCTweetSFResult = Result<PJCTweet, Error>

public typealias PJCTweetSFResponseHandler = (PJCTweetSFResult) -> Void

public protocol PJCTweetSFRequestDelegate
{
    func request(_ request: PJCTweetSFParameters,
                 completion: @escaping PJCTweetSFResponseHandler)
}

public class PJCTweetStatusesFilter
{
    // MARK: - Property(s)
    
    private(set) var dataStreamService: PJCDataStreamService
    
    fileprivate var oauthKeysAndTokens: OAuthKeysAndTokens
    
    
    // MARK: - Initialisation
    
    public init(_ oauthKeysAndTokens: OAuthKeysAndTokens)
    {
        self.dataStreamService = PJCDataStreamService()
        self.oauthKeysAndTokens = oauthKeysAndTokens
    }
    
    deinit
    { self.dataStreamService.disconnect() }
}

extension PJCTweetStatusesFilter: PJCAPIPathComponent
{
    static var relativePath: String
    { return "/1.1/statuses/filter.json" }
}

extension PJCTweetStatusesFilter: PJCTweetSFRequestDelegate
{
    public func request(_ parameters: PJCTweetSFParameters,
                        completion: @escaping PJCTweetSFResponseHandler)
    {
        let request = PJCAPIRequest(Self.relativePath,
                                    queryItems: parameters.queryItems)
        
        guard let signedRequest = try? request.signedUrlRequest(self.oauthKeysAndTokens).get() else
        {
            completion(.failure(PJCAPIError.requestNotSigned))
            return
        }
        
        let handler: PJCDataStreamServiceResponseHandler =
        { (data) in
            
            guard let tweet = try? JSONDecoder().decode(PJCTweet.self, from: data)  else
            {
                completion(.failure(PJCAPIError.invalidData))
                return
            }
            completion(.success(tweet))
        }
        
        self.dataStreamService.connect(with: signedRequest,
                                       responseHandler: handler)
    }
}

