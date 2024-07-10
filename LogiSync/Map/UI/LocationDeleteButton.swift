//
//  LocationDeleteButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/26.
//

import SwiftUI
import MapKit
import Combine

struct LocationDeleteButton: View {
    @State var isSheet: Bool = false
    @EnvironmentObject var environVM: EnvironmentViewModel
    @ObservedObject var mapVM: MapViewModel
    
    var body: some View {
        Button(action: {
            isSheet.toggle()
        }, label: {
            Image(systemName: "trash").foregroundStyle(environVM.model.account.user.role != "運転手" ? .gray : .red)
                .padding([.top, .bottom], 11)
                .padding([.leading, .trailing], 12)
        }).background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 7.0)).disabled(environVM.model.account.user.role != "運転手")
            .sheet(isPresented: $isSheet, content: {
                MapLocationDeleteSheet(mapVM: mapVM, user: environVM.model.account)
            }).onChange(of: isSheet) {
                mapVM.receivedLocationEvent.send(environVM.model.account.user.userId)
            }
    }
}

