//
//  MapBody.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import MapKit
import SwiftData


struct MapBody: View {
    
    
    @Query private var locationData: [LocationData]
    
    @Binding var mapTestData: MapViewTestData
    
    @ObservedObject var locationManager: LocationManager
    @EnvironmentObject var envModel: EnvModel
    @EnvironmentObject var environVM: EnvironmentViewModel
    
    @State private var userCameraPosition: MapCameraPosition = .automatic
    
    var sendCircleColor: UIColor = UIColor(red: 200, green: 30, blue: 0, alpha: 0.3)
    var destinationCircleColor: UIColor = UIColor(red: 200, green: 0, blue: 30, alpha: 0.3)
    
    @State var golLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State var index: Int = -1
    
    var body: some View {
        ZStack {
            Map(position: $userCameraPosition){

//                マッチング関係にある共有位置情報の取得
//                それらの表示
//                onApperの処理
                ForEach(envModel.nowMatchingLocations.indices, id: \.self) { index in
                    if envModel.nowMatchingLocations[index].userId == envModel.nowShipper.userId
                        {
                        Marker(coordinate: CLLocationCoordinate2D(latitude: envModel.nowMatchingLocations[index].latitude, longitude: envModel.nowMatchingLocations[index].longitude)){
                            VStack{
                                Text("\(envModel.nowMatchingLocations[index].createAt.description)\n\(envModel.nowMatchingLocations[index].status)")
                            }
                        }.tint(.green)
                        MapCircle(center: CLLocationCoordinate2D(latitude: envModel.nowMatchingLocations[index].latitude, longitude: envModel.nowMatchingLocations[index].longitude), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: sendCircleColor))
                    }
                }
                
                // ここから#14 目的地
                if golLocation.latitude != 0 {
                    Marker(coordinate: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude)) {
                        Text("目的地")
                    }.tint(.red)
                    MapCircle(center: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude), radius: CLLocationDistance(100)).foregroundStyle(Color(uiColor: destinationCircleColor))
                }
                
                UserAnnotation()
            }.mapControls {
                MapCompass()
                    .mapControlVisibility(.visible)
                MapPitchToggle()
                    .mapControlVisibility(.visible)
                MapScaleView()
                    .mapControlVisibility(.visible)
                MapUserLocationButton()
                    .mapControlVisibility(.visible)
            }.onAppear {
                // 目的地をもとに処理する
                locationManager.geoCoding(address: environVM.model.nowMatchingInformation.address) { position, err in
                    if let position = position {
                        self.golLocation = position
                        
                        userCameraPosition = .camera(MapCamera.init(centerCoordinate: locationManager.midpointCoordinate(coordinate1: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), coordinate2: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude)), distance: locationManager.distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), coordinate2: CLLocationCoordinate2D(latitude: golLocation.latitude, longitude: golLocation.longitude)) * 10))
                    }
                }
            }.onMapCameraChange {
                index = -1
            }
            
            VStack(){
//                Spacer()
                HStack{
                    Spacer()
                    MapCameraAutoButton(userCameraPosition: $userCameraPosition, locaMan: locationManager, index: $index, golLocation: $golLocation).padding(5).shadow(radius: 1)
                }
                Spacer().frame(height: 380)
            }
        }
        
    }
}
