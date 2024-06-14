//
//  MapView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        ZStack(content: {
            MapBody()
        })
    }
}

#Preview {
    MapView()
}
