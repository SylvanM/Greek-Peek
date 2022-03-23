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
     * Creates a route based on a coordinate and a name
     */
    init(name: String, latitude: Double, longitude: Double, difficulty: Difficulty, pathCoords: [CLLocationCoordinate2D]) {
        self.init(
            name: name,
            location: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            difficulty: difficulty,
            pathCoords: pathCoords
        )
    }
    
    init(name: String, location: CLLocationCoordinate2D, difficulty: Difficulty, pathCoords: [CLLocationCoordinate2D]) {
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
    
}
