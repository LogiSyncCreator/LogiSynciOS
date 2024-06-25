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
    @ObservedObject var locaMan: LocationManager
    @State var distance: [Double] = [1000, 10000, 100000]
    @Binding var index: Int
    @Binding var golLocation: CLLocationCoordinate2D
    var body: some View {
        Button(action: {
            
//            if let position = locaMan.location {
//                upIndex()
//                print(index)
//                userCameraPosition = .camera(MapCamera.init(centerCoordinate: position.coordinate, distance: distance[index]))
//            } else {
//                userCameraPosition = .automatic
//            }
            
            userCameraPosition = .camera(MapCamera.init(centerCoordinate: locaMan.midpointCoordinate(coordinate1: CLLocationCoordinate2D(latitude: locaMan.location?.coordinate.latitude ?? 0.0, longitude: locaMan.location?.coordinate.longitude ?? 0.0), coordinate2: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude)), distance: locaMan.distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D(latitude: locaMan.location?.coordinate.latitude ?? 0.0, longitude: locaMan.location?.coordinate.longitude ?? 0.0), coordinate2: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude)) * 10))
            
        }, label: {
            Image(systemName: "map").padding(11)
        }).background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 7.0))
    }
    
    func upIndex(){
        if index >= distance.count - 1 {
            index = 0
        } else {
            index += 1
        }
    }
}
