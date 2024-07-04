//
//  MapModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/04.
//

import Foundation

struct MapModel {
    var userLocations: [MatchingLocation] = []
    
    func retriveUserLocation(user: String) async throws -> [MatchingLocation] {
        do {
            let json = try await APIRequests().getUserLocation(user: user)
            print(json)
            return try JSONDecoder().decode([MatchingLocation].self, from: json)
        } catch {
            print("Json data is invalied")
            return []
        }
    }
}

struct MatchingLocation: Identifiable, Codable {
    var id: String = ""
    var userId: String = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var status: String = ""
    var createAt: String = ""
}
