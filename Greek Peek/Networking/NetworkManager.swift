//
//  NetworkManager.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/26/22.
//

import Foundation

class NetworkManager {
    
    // MARK: Properties
    
    // idk maybe have a URL here
    
    // MARK: Methods
    
    // idk if this should be static or not

    static func getAllRoutes(completion: @escaping ([Route]) -> ()) throws {
        
        let odysseyURL = URL(fileURLWithPath: Bundle.main.path(forResource: "odyssey", ofType: ".json")!)
        let eastMeadowsURL = URL(fileURLWithPath: Bundle.main.path(forResource: "east_meadows", ofType: ".json")!)
        let trojanURL = URL(fileURLWithPath: Bundle.main.path(forResource: "trojan", ofType: ".json")!)

        let allRoutes = try [odysseyURL, eastMeadowsURL, trojanURL].map { url in
            try Route(jsonData: Data(contentsOf: url))
        }
        
        completion(allRoutes)
    }
    
    // MARK: - Errors
    
    /**
     * Represents an error that can occur while networking
     */
    enum NetworkError: Error {
        case unknownError
    }
    
}
