//
//  LocationData.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/25.
//

import Foundation
import SwiftData

@Model
final class LocationData {
    var id: String
    var userId: String
    var longitude: Double
    var latitude: Double
    var createAt: Date
    var status: String
    var sending: Bool   // 送信歴
    
    init(id: String, userId: String, longitude: Double, latitude: Double, createAt: Date, status: String, sending: Bool) {
        self.id = id
        self.userId = userId
        self.longitude = longitude
        self.latitude = latitude
        self.createAt = createAt
        self.status = status
        self.sending = sending
    }
}
