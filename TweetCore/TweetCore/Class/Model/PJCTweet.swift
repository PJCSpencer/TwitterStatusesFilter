//
//  PJCTweet.swift
//  TweetMap
//
//  Created by Peter Spencer on 08/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


// MARK: - PJCTweet
public struct PJCTweet: Codable
{
    public let id: Int
    
    public let createdAt: String
    
    public let text: String
    
    public let coordinates: PJCCoordinates?
    
    public let geo: PJCGeo?
    
    public let lang: String?
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case createdAt  = "created_at"
        case text
        case coordinates
        case geo
        case lang
    }
}

