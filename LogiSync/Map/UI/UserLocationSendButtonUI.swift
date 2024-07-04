//
//  UserLocationSendButtonUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import SwiftData
import MapKit

struct UserLocationSendButtonUI: View {
    
    @Query private var local: [LocationData]
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var mapVM: MapViewModel
    @ObservedObject var lonMan: LocationManager
    @EnvironmentObject var environVM: EnvironmentViewModel
    
    var body: some View {
        Button {
            if environVM.model.account.user.role == "運転手" {
                if let location = lonMan.location?.coordinate {
                    mapVM.sendLocationEvent.send(SendLocation(user: environVM.model.account, location: location, message: environVM.model.account.status.name))
                }
            } else {
                Task{
                    // 更新処理
//                    try await envModel.setMatchingLocations()
                }
            }
        } label: {
            HStack{
                Image(systemName: "mappin.circle")
                Text(environVM.model.account.user.role == "運転手" ? "送信" : "受信")
            }.font(.title3).foregroundStyle(Color(.label)).padding()
        }.background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10.0))

    }
}

//#Preview {
//    UserLocationSendButtonUI()
//}
