//
//  Foundation+Additions.swift
//  TweetMap
//
//  Created by Peter Spencer on 07/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


extension Int
{
    func megabytes() -> Int
    { return self * 1024 * 1024 }
}

extension String
{
    static let upperLowerCharactersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    static func randomAlphaNumeric(count: Int) -> String
    {
        return String((0..<count).compactMap { (_) in upperLowerCharactersAndNumbers.randomElement() })
    }
}

extension CharacterSet
{
    static var extendedAlphanumerics: CharacterSet
    {
        var set = CharacterSet.alphanumerics
        set.insert(charactersIn: "*-._")
        
        return set
    }
}

