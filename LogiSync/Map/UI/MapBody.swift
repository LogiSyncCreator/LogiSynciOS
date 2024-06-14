//
//  MapBody.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit

struct MapBody: View {
    
    var sendCircleColor: UIColor = UIColor(red: 200, green: 30, blue: 0, alpha: 0.3)
    
    var body: some View {
        Map(){
            
            // ここから#11 送信したマップのサークル
            Marker(coordinate: CLLocationCoordinate2D(latitude: 35.168477, longitude: 136.8857)) {
                Text("22:30")
            }.tint(.red)
            MapCircle(center: CLLocationCoordinate2D(latitude: 35.168477, longitude: 136.8857), radius: CLLocationDistance(50)).foregroundStyle(Color(uiColor: sendCircleColor))
            // #11
        }
    }
}

#Preview {
    MapBody()
}
