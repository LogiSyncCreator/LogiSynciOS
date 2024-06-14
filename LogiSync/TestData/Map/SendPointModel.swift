//
//  SendPointModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import Foundation
import MapKit

struct SendPointModel {
    var point: CLLocationCoordinate2D
    var time: String
    var status: String
    
    init(point: CLLocationCoordinate2D, time: Date, status: String ) {
        self.point = point
        // DateをHH:mmの文字列にフォーマット
        self.time = "HH:mm"
        self.status = status
    }
}
