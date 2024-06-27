//
//  MapView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var mapTestData: MapViewTestData = MapViewTestData()
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var envModel: EnvModel
    var body: some View {
        ZStack(content: {
            MapBody(mapTestData: $mapTestData, locationManager: locationManager)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    UserLocationSendButtonUI(lonMan: locationManager)
                }
                Spacer().frame(height: 50)
            }.padding().onAppear(){
                Task{
                    if envModel.nowMatchingLocations.isEmpty {
                        try await envModel.setMatchingLocations()
                    }
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
