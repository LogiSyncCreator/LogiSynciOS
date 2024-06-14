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
    var body: some View {
        ZStack(content: {
            MapBody(mapTestData: $mapTestData)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    UserLocationSendButtonUI()
                }
            }.padding()
        })
    }
}

#Preview {
    MapView()
}
