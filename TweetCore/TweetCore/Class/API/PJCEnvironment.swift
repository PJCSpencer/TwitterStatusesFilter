//
//  PJCEnvironment.swift
//  TweetMap
//
//  Created by Peter Spencer on 06/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCHost: String
{
    case stream = "stream.twitter.com"
}

enum PJCEnvironment
{
    case develop
    
    case production
    
    
    // MARK: - Returning the Current Environment
    
    static var current: PJCEnvironment
    {
        return .develop // TODO:Expand ...
    }
    
    
    // MARK: - Returning the Host
    
    static var host: PJCHost
    {
        switch PJCEnvironment.current
        {
        case .develop, .production:
            return .stream
        }
    }
}

