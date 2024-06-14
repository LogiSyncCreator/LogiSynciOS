//
//  MapCameraAutoButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import SwiftUI
import MapKit

struct MapCameraAutoButton: View {
    @Binding var userCameraPosition: MapCameraPosition
    var body: some View {
        Button(action: {
            userCameraPosition = .automatic
        }, label: {
            Image(systemName: "map").padding(11)
        }).background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 7.0))
    }
}
