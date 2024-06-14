//
//  MapBody.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit

struct MapBody: View {
    
    @StateObject private var locationManager = LocationManager()
    
    var sendCircleColor: UIColor = UIColor(red: 200, green: 30, blue: 0, alpha: 0.3)
    var destinationCircleColor: UIColor = UIColor(red: 200, green: 0, blue: 30, alpha: 0.3)
    
    var body: some View {
        Map(){
            
            // ここから#11 送信したマップのサークル サークルサイズは50m
            Marker(coordinate: CLLocationCoordinate2D(latitude: 35.168477, longitude: 136.8857)) {
                Text("22:30")
            }.tint(.green)
            MapCircle(center: CLLocationCoordinate2D(latitude: 35.168477, longitude: 136.8857), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: sendCircleColor))
            // #11
            
            // ここから#14 目的地
            Marker(coordinate: CLLocationCoordinate2D(latitude: 34.763272, longitude: 137.381780)) {
                Text("目的地")
            }.tint(.red)
            MapCircle(center: CLLocationCoordinate2D(latitude: 34.763272, longitude: 137.381780), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: destinationCircleColor))
        }.onChange(of: locationManager.location) { oldValue, newValue in
            
        }
    }
}

#Preview {
    MapBody()
}
