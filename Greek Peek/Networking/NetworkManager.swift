//
//  NetworkManager.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/26/22.
//

import Foundation

class NetworkManager {
    
    // MARK: Properties
    
    private static let baseURL      = URL(string: "https://greekpeek.000webhostapp.com/")!
    
    private static let downloadURL  = baseURL.appendingPathComponent("download.php")
    private static let uploadURL    = baseURL.appendingPathComponent("upload.php")
    private static let scanURL      = baseURL.appendingPathComponent("scan.php")
    
    // MARK: Private Methods
    
    private static func scanRequest(completion: @escaping ([String]) -> ()) {
        var request = URLRequest(url: scanURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {                                              // check for fundamental networking error
                print("ERRORR")
                return
            }
            
            do {
                guard let allIdentifiers = try JSONSerialization.jsonObject(with: data) as? [[String : String]] else {
                    print("MAAAN")
                    return
                }
                
                let ids = allIdentifiers.map { $0["id"]! }
                completion(ids)
            } catch {
                print("Error decoding JSON:")
                print(error)
            }
        }

        task.resume()
    }
    
    private static func downloadRequest(id: String, completion: @escaping (String) -> ()) {
        var request = URLRequest(url: downloadURL)
        request.httpMethod = "GET"
        request.addValue(id, forHTTPHeaderField: "id")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {                                              // check for fundamental networking error
                print("ERRORR")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            completion(responseString)
        }

        task.resume()
    }
    
    // MARK: Public Methods
    
    /**
     *
     */
    public static func getAllIdentifiers(completion: @escaping ([String]) -> ()) {
        scanRequest(completion: completion)
    }
    
    public static func download(forID id: String, completion: @escaping (Data) -> ()) {
        downloadRequest(id: id) { encodedString in
            let decoded = Data(base64Encoded: encodedString)!
            completion(decoded)
        }
    }
    
    static func getAllRoutes(completion: @escaping ([Route]) -> ()) throws {
        
        getAllIdentifiers { identifiers in
            
            let routeCount = identifiers.count
            
            var collectedRoutes: [Route] = [] {
                didSet {
                    if collectedRoutes.count == routeCount {
                        completion(collectedRoutes)
                    }
                }
            }
            
            identifiers.forEach { id in
                download(forID: id) { jsonData in
                    do {
                        let route = try Route(jsonData: jsonData)
                        collectedRoutes.append(route)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    // MARK: - Errors
    
    /**
     * Represents an error that can occur while networking
     */
    enum NetworkError: Error {
        case unknownError
        case scanError
    }
    
}
