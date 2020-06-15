//
//  PJCTweetStatusesFilter+Additions.swift
//  TweetMap
//
//  Created by Peter Spencer on 11/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


extension PJCAPIRequest
{
    func signedUrlRequest(_ oauth: OAuthKeysAndTokens) -> Result<URLRequest, Error>
    {
        let parameters = OAuthParameters(oauth)
        
        // Creating the signature base string.
        guard let url = PJCAPIRequest(self.path).urlRequest(.post)?.url,
            let encodedUrl = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics) else
        { return .failure(OAuthError.invalidURL) }
        
        guard let parameterString = URLQueryItem.parameterString(parameters.queryItems + self.queryItems, encoded: true),
            let encodedParameterString = parameterString.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics) else
        { return .failure(OAuthError.invalidParameters) }
        
        let output = HTTPMethod.post.rawValue + "&" + encodedUrl + "&" + encodedParameterString
        
        // Getting a signing key.
        guard let signingKey = OAuthSigningKey(oauth) else
        { return .failure(OAuthError.invalidSigningKey) }
        
        // Calculating the signature.
        guard let signature = output.HMAC(signingKey: signingKey) else
        { return .failure(OAuthError.invalidSignature) }
        
        let signedParameters = OAuthSignedParameters(parameters: parameters,
                                                     signature: signature)
        
        // Authorizing a request.
        guard let signedRequest = URLComponents.from(self).signedUrlRequest(signedParameters) else
        { return .failure(OAuthError.invalidRequest) }
        
        return .success(signedRequest)
    }
}

extension URLQueryItem
{
    static func parameterString(_ items: [URLQueryItem],
                                encoded: Bool = false) -> String?
    {
        var buffer: [String] = []
        let sorted = items.sorted(by: { $0.name < $1.name })
         
        sorted.forEach
        {
            if encoded
            {
                guard let encodedName = $0.name.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics),
                    let encodedValue = $0.value?.addingPercentEncoding(withAllowedCharacters: .extendedAlphanumerics) else
                { return }
                
                buffer.append(#"\#(encodedName)=\#(encodedValue)"#)
            }
            else
            {
                guard let value = $0.value else
                { return }
                
                buffer.append(#"\#($0.name)=\#(value)"#)
            }
        }
        
        let seperator: String = "&"
        let result = buffer.map({ $0 + seperator }).reduce("", +)
        
        return String(result.dropLast(seperator.count))
    }
}

