//
//  StartMonitoringRegion.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/05.
//

import SwiftUI
import MapKit
import Combine

struct StartMonitoringRegion: View {
    @State var isStartAlert: Bool = false
    @State var isEndAlert: Bool = false
    @EnvironmentObject var locationMan: LocationManager
    @EnvironmentObject var environVM: EnvironmentViewModel
    @Binding var goalLocation: CLLocationCoordinate2D
    @Binding var sendLocationEvent: PassthroughSubject<SendLocation, Never>
    @Binding var receivedLocationEvent: PassthroughSubject<String, Never>
    @ObservedObject var mapVM: MapViewModel
    
    var body: some View {
        Button(action: {
            if !locationMan.updateLocationstart {
                isStartAlert.toggle()
            } else {
                isEndAlert.toggle()
            }
        }, label: {
            Image(systemName: "truck.box.fill")
                .foregroundStyle(
                    locationMan.updateLocationstart ?
                    Color(.red) :
                        environVM.model.account.user.role != "運転手" || environVM.model.nowMatchingInformation.address.isEmpty ?
                    Color(.gray) :
                        Color(.blue)
                )
                .padding([.top, .bottom], 11)
                .padding([.leading, .trailing], 8)
        }).background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 7.0)).disabled(environVM.model.account.user.role != "運転手" || environVM.model.nowMatchingInformation.address.isEmpty)
            .alert("警告", isPresented: $isStartAlert) {
                Button("OK") {
                    locationMan.updateLocationstart.toggle()
                    locationMan.targetLocation = goalLocation
                    locationMan.targetMatching = environVM.model.nowMatchingInformation
                    locationMan.targetUser = environVM.model.nowMatchingUser
                    locationMan.myUser = environVM.model.account
                    mapVM.sendLocationEvent.send(SendLocation(user: environVM.model.account, location: locationMan.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), message: "位置情報共有開始", matching: locationMan.targetMatching))
                    print(locationMan.targetMatching)
                    Task {
                        try? await APIRequests().sendUserMessage(user: locationMan.targetMatching.shipper, message: "\(environVM.model.account.user.company):\(environVM.model.account.user.name)\n運転開始につき\(locationMan.intervalTime)分おきに位置情報を共有します。")
                        try? await locationMan.liveUpdates(locationMan.rudius, user: environVM.model.account, sendLocationEvent: sendLocationEvent, receivedLocationEvent: receivedLocationEvent)
                    }
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("運転を開始しますか？\nOKを押すことで目的地の付近で相手に通知を送信したり一定時間おきに位置情報を共有します。")
            }
            .alert("警告", isPresented: $isEndAlert) {
                Button("OK") {
                    let receiver = locationMan.targetMatching.shipper
                    Task {
                        try? await APIRequests().sendUserMessage(user: receiver, message: "\(environVM.model.account.user.company):\(environVM.model.account.user.name)\n運転終了につき位置情報の共有を停止します。")
                    }
                    locationMan.updateLocationstart.toggle()
                    locationMan.updateLocationFlag.toggle()
                    locationMan.targetLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    locationMan.targetMatching = MatchingInformation()
                    locationMan.targetUser = MyUser()
//                    locationMan.myUser = MyUser()
                    print(locationMan.targetMatching)
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("運転を終了しますか？")
            }
    }
}
