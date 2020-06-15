//
//  PJCOAuth.swift
//  TweetMap
//
//  Created by Peter Spencer on 11/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


public protocol OAuthProvider
{
    static var oauthKeysAndTokens: OAuthKeysAndTokens { get }
}

public enum OAuthError: Error
{
    case failed
    case invalidParameters
    case invalidURL
    case invalidSigningKey
    case invalidSignature
    case invalidRequest
    case unkown
}

enum OAuthKey: String
{
    case oauth                  = "OAuth"
    
    case oauthConsumerKey       = "oauth_consumer_key"
    case oauthNonce             = "oauth_nonce"
    case oauthSignature         = "oauth_signature"
    case oauthSignatureMethod   = "oauth_signature_method"
    case oauthTimestamp         = "oauth_timestamp"
    case oauthToken             = "oauth_token"
    case oauthVersion           = "oauth_version"
}

public struct OAuthKeysAndTokens
{
    // https://developer.twitter.com/en/docs/basics/apps/guides/the-app-management-dashboard
    // https://developer.twitter.com/en/docs/basics/authentication/oauth-1-0a/obtaining-user-access-tokens
    
    // MARK: - Consumer API keys
    
    let apiKey: String
    let apiSecretKey: String
    
    
    // MARK: - Access token & access token secret
    
    let accessToken: String
    let accessTokenSecret: String
    
    public init(apiKey: String,
                apiSecretKey: String,
                accessToken: String,
                accessTokenSecret: String)
    {
        self.apiKey = apiKey
        self.apiSecretKey = apiSecretKey
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
    }
}

struct OAuthParameters
{
    let consumerKey: String         // API key
    let nonce: String
    let signatureMethod: String = "HMAC-SHA1"
    let timestamp: String
    let token: String               // Access token
    let version: String = "1.0"
    
    init(_ oauth: OAuthKeysAndTokens)
    {
        self.consumerKey = oauth.apiKey
        self.nonce = String.randomAlphaNumeric(count: 32)
        self.timestamp = String(Int(Date().timeIntervalSince1970))
        self.token = oauth.accessToken
    }
}

extension OAuthParameters: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuthKey.oauthConsumerKey.rawValue, value: self.consumerKey))
        buffer.append(URLQueryItem(name: OAuthKey.oauthNonce.rawValue, value: self.nonce))
        buffer.append(URLQueryItem(name: OAuthKey.oauthSignatureMethod.rawValue, value: self.signatureMethod))
        buffer.append(URLQueryItem(name: OAuthKey.oauthTimestamp.rawValue, value: self.timestamp))
        buffer.append(URLQueryItem(name: OAuthKey.oauthToken.rawValue, value: self.token))
        buffer.append(URLQueryItem(name: OAuthKey.oauthVersion.rawValue, value: self.version))
        
        return buffer
    }
}

struct OAuthSignedParameters
{
    let parameters: OAuthParameters
    let signature: String
}

extension OAuthSignedParameters: CustomStringConvertible
{
    var description: String
    {
        var items: [URLQueryItem] = self.parameters.queryItems
        items.append(URLQueryItem(name: OAuthKey.oauthSignature.rawValue, value: self.signature))
        
        let sorted = items.sorted(by: { $0.name < $1.name })
        var buffer: [String] = []
        
        sorted.forEach
        {
            guard let encodedName = $0.name.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics),
                let encodedValue = $0.value?.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics) else
            { return }
            
            buffer.append(#"\#(encodedName)="\#(encodedValue)""#)
        }
        
        let seperator: String = ", "
        let result = buffer.map({ $0 + seperator }).reduce("", +)
        
        return "\(OAuthKey.oauth.rawValue) " + String(result.dropLast(seperator.count))
    }
}

struct OAuthSigningKey
{
    let percentEncodedValue: String
    
    init?(_ oauth: OAuthKeysAndTokens)
    {
        guard let consumerSecret = oauth.apiSecretKey.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics),
            let oauthTokenSecret = oauth.accessTokenSecret.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics) else
        { return nil }
        
        self.percentEncodedValue = "\(consumerSecret)&\(oauthTokenSecret)"
    }
}

public struct OAuthSignature { /* TODO: */ }

