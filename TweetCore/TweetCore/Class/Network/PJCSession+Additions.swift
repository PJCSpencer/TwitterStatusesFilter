//
//  PJCSession+Additions.swift
//  TweetMap
//
//  Created by Peter Spencer on 05/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCServiceError: Error
{
    case failed, unkown, badResponse, unkownData
    
    // 200.
    case success
    
    // 300.
    case redirection
    
    // 400.
    case clientError
    case badRequest, unauthorized, forbidden, notFound, requestTimeout
    
    // 500.
    case serverError
    case internalServerError, notImplemented, serviceUnavailable
    case permissionDenied
    
    var statusCode: Int
    {
        switch self
        {
        case .success:
            return 200
        case .redirection:
            return 300
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .requestTimeout:
            return 408
        default:
            return 0
        }
    }
    
    static func status(_ statusCode: Int) -> PJCServiceError
    {
        switch statusCode
        {
        case 200...208:
            return .success
        case 300...308:
            return .redirection
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405...407:
            return .clientError
        case 408:
            return .requestTimeout
        case 409...451:
            return .clientError
        case 500:
            return .internalServerError
        case 501:
            return .notImplemented
        case 502:
            return .serverError
        case 503:
            return .serviceUnavailable
        case 504...511:
            return .serverError
        case 550:
            return .permissionDenied
        default:
            return .failed
        }
    }
}

enum StatusCode: Int
{
    // 200.
    case success        = 200
    
    // 300
    case redirection    = 300
    
    // 400.
    case badRequest     = 400
    case unauthorized   = 401
    case forbidden      = 403
    case requestTimeout = 408
}

enum HTTPHeaderField: String
{
    case authorization  = "Authorization"
    case contentType    = "Content-Type"
    case contentLength  = "Content-Length"
}

enum HTTPScheme: String
{
    case http       = "http"
    case https      = "https"
}

enum HTTPMethod: String
{
    case get        = "GET"
    case post       = "POST"
    case delete     = "DELETE"
}

struct ContentType
{
    // MARK: - Constant(s)
    
    static let supportedMIMETypes: [String:MIMEType] =
    [
        MIMETypeApplication.json.description    : MIMETypeApplication.json,
        MIMETypeImage.jpeg.description          : MIMETypeImage.jpeg,
        MIMETypeImage.png.description           : MIMETypeImage.png,
        MIMETypeText.html.description           : MIMETypeText.html
    ]
    
    
    // MARK: - Property(s)
    
    let mimeType: MIMEType
    
    
    // MARK: - Initialisation
    
    init(_ mimeType: MIMEType)
    { self.mimeType = mimeType }
    
    init?(_ string: String?)
    {
        guard let trimmed = string?.lowercased().trimmingCharacters(in: .whitespaces),
            let first = trimmed.split(separator: ";").first,
            let key = String(first) as String?,
            let value = Self.supportedMIMETypes[key] else
        { return nil }
        
        self.mimeType = value
    }
}

// MARK: - Equatable
extension ContentType: Equatable
{
    static func == (lhs: ContentType,
                    rhs: ContentType) -> Bool
    { return lhs.mimeType.description == rhs.mimeType.description }
}

protocol MIMEType: CustomStringConvertible {}

enum MIMETypeApplication: String // TODO:Support extension protocol ..?
{
    // MARK: - Constant(s)
    
    static let domain: String = "application"
    
    case json
}

// MARK: - CustomStringConvertible
extension MIMETypeApplication: MIMEType
{
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

enum MIMETypeImage: String
{
    // MARK: - Constant(s)
    
    static let domain: String = "image"
    
    case gif
    case jpeg
    case png
}

// MARK: - CustomStringConvertible
extension MIMETypeImage: MIMEType
{
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

enum MIMETypeText: String
{
    // MARK: - Constant(s)
    
    static let domain: String = "text"
    
    case html
}

// MARK: - CustomStringConvertible
extension MIMETypeText: MIMEType
{
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

