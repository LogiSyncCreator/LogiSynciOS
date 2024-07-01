//
//  SettingsSheet.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var environVM: EnvironmentViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var viewIndex: Int
    var body: some View {
        
        NavigationStack {
            List {
                NavigationLink("マッチングリスト") {
                    List {
                        ForEach(environVM.model.matchings, id: \.matching.id){ matching in
                            Button {
                                environVM.model.nowMatching = matching.index
                                environVM.changeMatchingCalled.send()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("\(environVM.model.account.user.role == "運転手" ? matching.user.shipper.company : matching.user.driver.company )：\(environVM.model.account.user.role == "運転手" ? matching.user.shipper.name : matching.user.driver.name )")
                            }
                        }
                    }
                }
                Button(action: {
                    environVM.changeLogoutCalled.send(())
                    environVM.initModels()
                    withAnimation {
                        viewIndex = 3
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("ログアウト")
                }).foregroundStyle(Color(.red))
            }.foregroundStyle(Color(.label))
        }
    }
}
