//
//  UserLocationSendButtonUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI
import SwiftData

struct UserLocationSendButtonUI: View {
    
    @ObservedObject var lonMan: LocationManager
    @Environment(\.modelContext) private var modelContext
    @Query private var local: [LocationData]
    @EnvironmentObject var envModel: EnvModel
    
    var body: some View {
        Button {
            if envModel.user.role == "運転手" {
                if let location = lonMan.location {
                    let newModel = LocationData(id: UUID().uuidString, userId: envModel.user.userId, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, createAt: Date(), status: envModel.nowStatus.name, sending: false)
                    modelContext.insert(newModel)
                    try! modelContext.save()
                }
            } else {
                Task{
                    try await envModel.setMatchingLocations()
                }
            }
        } label: {
            HStack{
                Image(systemName: "mappin.circle")
                Text(envModel.user.role == "運転手" ? "送信" : "受信")
            }.font(.title3).foregroundStyle(Color(.label)).padding()
        }.background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10.0))

    }
}

//#Preview {
//    UserLocationSendButtonUI()
//}
