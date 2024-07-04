//
//  MapView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

// 位置情報の取得

import SwiftUI
import MapKit

struct MapView: View {
    @State var mapTestData: MapViewTestData = MapViewTestData()
    @StateObject var mapVM: MapViewModel = MapViewModel()
    @StateObject var locationManager = LocationManager()
//    @EnvironmentObject var envModel: EnvModel
    var body: some View {
        ZStack(content: {
            MapBody(mapTestData: $mapTestData, locationManager: locationManager, mapVM: mapVM)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    UserLocationSendButtonUI(mapVM: mapVM, lonMan: locationManager)
                }
                Spacer().frame(height: 50)
            }.padding()
        })
    }
}

#Preview {
    ContentView().environmentObject(EnvironmentViewModel())
}
