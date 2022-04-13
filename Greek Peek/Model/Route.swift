//
//  Route.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/23/22.
//

import Foundation
import MapKit



/**
 * A Ski Route
 */
struct Route {
    
    // MARK: Properties
    
    /**
     * A unique identifier for every route
     */
    let identifier: Int
    
    /**
     * The coordinates of the starting location of the route
     */
    let generalCoords: CLLocationCoordinate2D
    
    /**
     * The list of coordinates that define this path
     */
    let pathCoords: [CLLocationCoordinate2D]
    
    /**
     * The name of the route
     */
    let name: String
    
    /**
     * The difficulty of the route
     */
    let difficulty: Difficulty
    
    // MARK: Initializers
    
    /**
     * Creates a `Route` based on a `JSON` object
     */
    init(jsonData: Data) throws {
        
        print("Creating json object")
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] {
                
                if let id = json["id"] as? Int {
                    self.identifier = id
                } else {
                    throw RouteError.jsonDecodingError("no id")
                }
                
                if let name = json["name"] as? String {
                    self.name = name
                } else {
                    throw RouteError.jsonDecodingError("name")
                }
                
                if let difficultyValue = json["difficulty"] as? Int {
                    guard let difficulty = Difficulty(rawValue: difficultyValue) else {
                        throw RouteError.jsonDecodingError("invalid difficulty")
                    }
                    self.difficulty = difficulty
                } else {
                    throw RouteError.jsonDecodingError("difficulty")
                }
                
                if let latitude = json["latitude"] as? Double, let longitude = json["longitude"] as? Double {
                    self.generalCoords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                } else {
                    throw RouteError.jsonDecodingError("coords")
                }
                
                if let path = json["path"] as? [[Double]] {
                    self.pathCoords = path.map { coords in
                        CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
                    }
                } else {
                    throw RouteError.jsonDecodingError("path")
                }
                
                
            } else {
                throw RouteError.jsonDecodingError("nil json")
            }
        } catch {
            throw RouteError.jsonDecodingError("JSON Serialization Error")
        }
        
    }
    
    /**
     * Creates a route based on a coordinate and a name
     */
    init(id: Int, name: String, latitude: Double, longitude: Double, difficulty: Difficulty, pathCoords: [CLLocationCoordinate2D]) {
        self.init(
            id: id,
            name: name,
            location: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            difficulty: difficulty,
            pathCoords: pathCoords
        )
    }
    
    init(id: Int, name: String, location: CLLocationCoordinate2D, difficulty: Difficulty, pathCoords: [CLLocationCoordinate2D]) {
        self.identifier = id
        self.name = name
        self.generalCoords = location
        self.difficulty = difficulty
        self.pathCoords = pathCoords
    }
    
    // MARK: Enumerations
    
    /**
     * The difficulty of a route
     */
    enum Difficulty: Int {
        case green = 0
        case blue = 1
        case black = 2
        case doubleBlack = 3
        
        var asString: String {
            switch self {
            case .green:
                return "Green"
            case .blue:
                return "Blue"
            case .black:
                return "Black Diamond"
            case .doubleBlack:
                return "Double Black Diamond"
            }
        }
        
        var color: UIColor {
            switch self {
            case .green:
                return UIColor.green
            case .blue:
                return UIColor.blue
            case .black:
                return UIColor.black
            case .doubleBlack:
                return UIColor.black
            }
        }
    }
    
    // MARK: Errors
    
    /**
     * An error that can occur with a `Route` state
     */
    enum RouteError: Error {
        
        /**
         * Thrown when a certain JSON object cannot be decoded into a `Route`
         */
        case jsonDecodingError(String)
        
    }
    
}
