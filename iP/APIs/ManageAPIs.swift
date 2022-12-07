//
//  ManageAPIs.swift
//  iP
//
//  Created by Andy Hoo on 12/7/22.
//

import Foundation
import SwiftUI

struct IP: Decodable {
    var ip: String
}

struct IPGeo: Decodable {
    var city: String
    var country: String
    var timezone: String
}

struct IPCoordinates: Decodable {
    var latitude: Double
    var longitude: Double
}

class ManageAPIs: ObservableObject {

    func callData<T: Decodable>(url: String, model: T.Type, completion:@escaping(T) -> (), failure:@escaping(Error) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                // If there is an error, return the error.
                if let error = error { failure(error) }
                return
            }
            
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                // Return the data successfully from the server
                completion((serverData))
            } catch {
                // If there is an error, return the error.
                failure(error)
            }
        }
        .resume()
    }
}
