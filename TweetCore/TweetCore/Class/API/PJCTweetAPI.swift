//
//  PJCTweetAPI.swift
//  TweetMap
//
//  Created by Peter Spencer on 06/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol PJCQueryProvider
{
    var queryItems: [URLQueryItem] { get }
}

protocol PJCURLRequestProvider
{
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
}

// MARK: - Protocol(s)
protocol PJCAPIPathComponent
{
    static var relativePath: String { get }
}

protocol PJCAPIParameterComponent
{
    var apiParameter: String { get }
}

// MARK: - PJCAPIError
enum PJCAPIError: Error
{
    case none
    case failed, canceled
    case requestNotSigned
    case invalidData
    case unknown
}

// MARK: - PJCGenericAPIRequest
struct PJCGenericAPIRequest<T: PJCAPIPathComponent>
{
    let type: T.Type
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ type: T.Type,
         queryItems: [URLQueryItem] = [])
    {
        self.type = type
        self.queryItems = queryItems
    }
}

// MARK: - PJCAPIRequest
struct PJCAPIRequest
{
    let path: String // TODO:Evolve to support PJCGenericAPIRequest ..?
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ path: String,
         queryItems: [URLQueryItem]? = nil)
    {
        self.path = path
        self.queryItems = queryItems ?? []
    }
}

extension PJCAPIRequest: PJCURLRequestProvider
{
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
    { return URLComponents.from(self).urlRequest(method) }
}

// MARK: - PJCAPIDataResponse
public struct PJCAPIDataResponse<T>
{
    // MARK: - Property(s)
    
    let objects: [T]
    
    let indexPaths: [IndexPath]
    
    
    // MARK: - Initialiser(s)
    
    init(_ objects: [T]? = nil,
         indexPaths: [IndexPath]? = nil)
    {
        self.objects = objects ?? []
        self.indexPaths = indexPaths ?? []
    }
}

