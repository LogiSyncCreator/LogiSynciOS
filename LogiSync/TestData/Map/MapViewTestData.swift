//
//  MapViewTestData.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import Foundation
import MapKit
import SwiftUI

struct MapViewTestData {
    
    // 目的地の座標
    @State var destinationPoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.763272, longitude: 137.381780)
    
    // 送信した座標
    @State var sendPoints: [SendPointModel] = [
        SendPointModel(point: CLLocationCoordinate2D(latitude: 35.170915, longitude: 136.881537), time: Date(), status: "送信"),
        SendPointModel(point: CLLocationCoordinate2D(latitude: 35.005874, longitude: 137.039717), time: Date(), status: "休憩"),
        SendPointModel(point: CLLocationCoordinate2D(latitude: 34.951016, longitude: 137.261897), time: Date(), status: "オフライン"),
    ]
    
    
}
