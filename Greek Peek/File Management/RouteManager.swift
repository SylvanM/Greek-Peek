//
//  RouteManager.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/30/22.
//

import Foundation

/**
 * This class is meant to help access routes that are saved to the device, and to retrieve new routes from the internet
 */
class RouteManager {
    
    /**
     * A function returning whether or not a route meets a specific criteria
     */
    typealias RouteFilter = (Route) -> Bool
    
    // MARK: Public Properties
    
    /**
     * Whether or not routes have been loaded
     */
    static var routesLoaded: Bool {
        !allRoutes.isEmpty
    }
    
    /**
     * The delegate for this manager
     */
    static var delegate: RouteManagerDelegate?
    
    // MARK: Methods
    
    /**
     * Returns all routes that meet a certain filter
     */
    static func getRoutes(matching filter: RouteFilter) -> [Route] {
        allRoutes.filter(filter)
    }
    
    // MARK: Filters
    
    /**
     * A filter matching all routes of a specific name
     */
    public static func matchingRoutes(ofName name: String) -> RouteFilter {
        { $0.name == name }
    }
    
    // MARK: Private Methods
    
    /**
     * Downloads all routes and saves them to a directory on the user's phone
     */
    private static func downloadRoutes() {
        
    }
    
    /**
     *
     */

    
    // MARK: Private Variables
    
    /**
     * This will be computed upon launch. On first launch of the app, we will need to query the backend. From then on, we just
     * read the files that are saved on the device.
     */
    private static var allRoutes: [Route] = []
    
}
