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
    
    // MARK: Private Properties
    
    private static var delegates: [RouteManagerDelegate] = []
    
    private static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private static var routesDirectory  = documentsDirectory.appendingPathComponent("routes", isDirectory: true)
    
    // MARK: Helper Methods
    
    private static func forEachFile(inDirectory directory: URL, forEach: (URL) -> ()) {
        let enumerator = FileManager().enumerator(at: directory, includingPropertiesForKeys: nil)
        
        while let url = enumerator?.nextObject() as? URL {
            forEach(url)
        }
        
    }
    
    private static func forEachRoute(forEach: (Route) -> ()) {
        forEachFile(inDirectory: routesDirectory) { url in
            do {
                let jsonData = try Data(contentsOf: url)
                let route = try Route(jsonData: jsonData)
                forEach(route)
            } catch {
                print("Couldn't read route:")
                print(error)
            }
        }
    }
    
    private static func write(name: String, data: Data, toDirectory directory: URL) {
        let fileURL = directory.appendingPathComponent(name)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Could not write \(name) to file:")
            print(error)
        }
    }
    
    private static func writeRoute(name: String, data: Data) {
        write(name: name, data: data, toDirectory: routesDirectory)
    }

    
    // MARK: Methods
    
    static func addDelegate(_ delegate: RouteManagerDelegate) {
        delegates.append(delegate)
    }
    
    /**
     * Checks the local file directory to see if files are loaded, and requests files from the server if need be.
     */
    static func onLaunch() {
        downloadRoutes {
            delegates.forEach { d in
                d.routesReloaded()
            }
        }
    }
    
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
    private static func downloadRoutes(completion: @escaping () -> ()) {
        NetworkManager.getAllIdentifiers { identifiers in
            identifiers.forEach { id in
                NetworkManager.download(forID: id) { jsonData in
                    // Write the JSON data to files on the user's computer
                    writeRoute(name: id, data: jsonData)
                }
            }
        }
    }

    /**
     * Reads all routes stores locally on the device
     */
    private static func readRoutes() -> [Route] {
        var routes: [Route] = []
        forEachRoute { route in
            routes.append(route)
        }
        return routes
    }
    
    // MARK: Private Variables
    
    /**
     * This will be computed upon launch. On first launch of the app, we will need to query the backend. From then on, we just
     * read the files that are saved on the device.
     */
    public static var allRoutes: [Route] {
        readRoutes()
    }
    
}
