//
//  URLSession+Additions.swift
//  TweetMap
//
//  Created by Peter Spencer on 06/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


// MARK: - URLSessionConfiguration
extension URLSessionConfiguration
{
    class func named(_ path: String) -> URLSessionConfiguration
    {
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.allowsCellularAccess = false
        anObject.waitsForConnectivity = true
        anObject.urlCache = URLCache(memoryCapacity: 5.megabytes(),
                                     diskCapacity: 20.megabytes(),
                                     diskPath: path)
        
        return anObject
    }
}

// MARK: - URLComponents
extension URLComponents
{
    static func from(_ request: PJCAPIRequest,
                     scheme: HTTPScheme = HTTPScheme.https,
                     host: PJCHost = PJCEnvironment.host) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host.rawValue
        components.path = request.path
        components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems
        
        return components
    }
}

extension URLComponents: PJCURLRequestProvider
{
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
    {
        guard let url = self.url else
        { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = method?.rawValue ?? HTTPMethod.get.rawValue
        
        return request
    }
    
    func signedUrlRequest(_ parameters: OAuthSignedParameters) -> URLRequest?
    {
        guard let url = self.url else
        { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(parameters.description,
                         forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        
        return request
    }
}

