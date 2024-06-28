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
                Button(action: {}, label: {
                    Text("アカウントの情報確認")
                })
                Button(action: {
                }, label: {
                    Text("ログアウト")
                }).foregroundStyle(Color(.red))
                Button(action: {}, label: {
                    Text("アカウントの削除")
                }).foregroundStyle(Color(.red))
            }.foregroundStyle(Color(.label))
        }
    }
}

#Preview {
    SettingsSheet().environmentObject(EnvironmentViewModel())
}
