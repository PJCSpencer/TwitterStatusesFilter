//
//  PJCCrypto.swift
//  TweetMap
//
//  Created by Peter Spencer on 09/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation
import CommonCrypto


extension String
{
    func HMAC(signingKey: OAuthSigningKey) -> String? // TODO:Support OAuthSignature ...
    { return HMAC(key: signingKey.percentEncodedValue) }
    
    func HMAC(key: String) -> String?
    {
        guard let keyBytes = key.cString(using: .utf8),
            let dataBytes = self.cString(using: .utf8) else
        { return nil }
        
        let keyLength = Int(CC_SHA1_DIGEST_LENGTH)
        var macOut = [UInt8](repeating: 0,
                             count: keyLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),
               keyBytes,
               keyBytes.count-1,
               dataBytes,
               dataBytes.count-1,
               &macOut)
          
        return Data(bytes: macOut,
                    count: macOut.count).base64EncodedString()
    }
}

