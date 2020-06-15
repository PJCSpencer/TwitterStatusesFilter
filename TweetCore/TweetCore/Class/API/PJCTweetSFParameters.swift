//
//  PJCTweetSFParameters.swift
//  TweetMap
//
//  Created by Peter Spencer on 11/06/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation
import CoreLocation


// MARK: - PJCTweetSFParameters
public struct PJCTweetSFParameters
{
    let track: PJCTweetSFTrack
    
    let locations: [PJCCoordinates]?
    
    public init(_ track: PJCTweetSFTrack,
         locations: [PJCCoordinates]? = nil)
    {
        self.track = track
        self.locations = locations ?? nil
    }
}

extension PJCTweetSFParameters: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        return self.track.queryItems
    }
}

// MARK: - PJCTweetSFTrack
public struct PJCTweetSFTrack
{
    let items: [PJCTweetSFTrackItem]
    
    public init(items: [PJCTweetSFTrackItem])
    {
        self.items = items
    }
}

extension PJCTweetSFTrack: PJCAPIParameterComponent
{
    var apiParameter: String
    { return "track" }
}

extension PJCTweetSFTrack: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        let seperator: String = ", "
        let result = self.items.map({ $0.value + seperator }).reduce("", +)

        return [URLQueryItem(name: self.apiParameter, value: String(result.dropLast(seperator.count)))]
    }
}

// MARK: - PJCTweetSFTrackItem
public struct PJCTweetSFTrackItem
{
    let value: String
    
    public init?(_ string: String)
    {
        guard !string.contains(","),
            string.count <= 60 else
        { return nil }
        
        self.value = string
    }
}

// MARK: - PJCSearchRadiusUnit
enum PJCSearchRadiusUnit: String
{
    case kilometers = "km"
    case miles      = "mi"
}

// MARK: - PJCSearchRadius
struct PJCSearchRadius
{
    let unit: PJCSearchRadiusUnit // NB:Could use MeasurementFormatter here.
    
    let value: Int
    
    init(_ value: Int,
         unit: PJCSearchRadiusUnit)
    {
        self.value = value
        self.unit = unit
    }
}

extension PJCSearchRadius: CustomStringConvertible
{
    var description: String
    { return String(self.value) + self.unit.rawValue }
}

// MARK: - PJCLocation
struct PJCLocation
{
    let coordinate2D: CLLocationCoordinate2D
    
    let radius: PJCSearchRadius
    
    init?(_ coordinate: CLLocationCoordinate2D,
          radius: PJCSearchRadius)
    {
        guard CLLocationCoordinate2DIsValid(coordinate) else
        { return nil }
        
        self.coordinate2D = coordinate
        self.radius = radius
    }
}

extension PJCLocation: PJCAPIParameterComponent
{
    var apiParameter: String
    { return "geocode" }
}

extension PJCLocation: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        let value: String = String(self.coordinate2D.latitude) + ","
            + String(self.coordinate2D.longitude) + ","
            + self.radius.description
        
        return [URLQueryItem(name: self.apiParameter, value: value)]
    }
}

// MARK: - PJCGeo
public struct PJCGeo: Codable
{
    let coordinates: PJCCoordinates?
    
    let placeId: String
    
    enum CodingKeys: String, CodingKey
    {
        case coordinates
        case placeId = "place_id"
    }
}

// MARK: - PJCCoordinates
public struct PJCCoordinates: Codable
{
    let type: String
    
    let coordinates: [Double]
}

extension PJCCoordinates // TODO:Support protocol ...
{
    public func locationCoordinates2D() -> CLLocationCoordinate2D?
    {
        guard let lat = self.coordinates.first,
            let lon = self.coordinates.last else
        { return nil }
        
        return CLLocationCoordinate2D(latitude: lat,
                                      longitude: lon)
    }
}

