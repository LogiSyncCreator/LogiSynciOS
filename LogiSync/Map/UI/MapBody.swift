//
//  MapBody.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit



struct MapBody: View {
    
    @Binding var mapTestData: MapViewTestData
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var userCameraPosition: MapCameraPosition = .automatic
    
    var sendCircleColor: UIColor = UIColor(red: 200, green: 30, blue: 0, alpha: 0.3)
    var destinationCircleColor: UIColor = UIColor(red: 200, green: 0, blue: 30, alpha: 0.3)
    
    var body: some View {
        ZStack {
            Map(position: $userCameraPosition){
                UserAnnotation()
                // ここから#11 送信したマップのサークル サークルサイズは50m
                ForEach(mapTestData.sendPoints.indices, id: \.self){index in
                    Marker(coordinate: CLLocationCoordinate2D(latitude: mapTestData.sendPoints[index].point.latitude, longitude: mapTestData.sendPoints[index].point.longitude)) {
                        VStack{
                            Text("\(mapTestData.sendPoints[index].time)\n\(mapTestData.sendPoints[index].status)")
                        }
                    }.tint(.green)
                    MapCircle(center: CLLocationCoordinate2D(latitude: mapTestData.sendPoints[index].point.latitude, longitude: mapTestData.sendPoints[index].point.longitude), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: sendCircleColor))
                }
                // #11
                
                // ここから#14 目的地
                Marker(coordinate: CLLocationCoordinate2D(latitude: 34.763272, longitude: 137.381780)) {
                    Text("目的地")
                }.tint(.red)
                MapCircle(center: CLLocationCoordinate2D(latitude: 34.763272, longitude: 137.381780), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: destinationCircleColor))
            }.mapControls {
                MapCompass()
                    .mapControlVisibility(.visible)
                MapPitchToggle()
                    .mapControlVisibility(.visible)
                MapScaleView()
                    .mapControlVisibility(.visible)
                MapUserLocationButton()
                    .mapControlVisibility(.visible)
            }
            
            VStack(){
//                Spacer()
                HStack{
                    Spacer()
                    MapCameraAutoButton(userCameraPosition: $userCameraPosition).padding(5).shadow(radius: 1)
                }
                Spacer().frame(height: 380)
            }
        }
        
    }
}
