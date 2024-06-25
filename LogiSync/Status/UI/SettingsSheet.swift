//
//  SettingsSheet.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var envModel: EnvModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        NavigationStack {
            List {
                NavigationLink("マッチングリスト") {
                    List {
                        ForEach(envModel.matchSort.indices){ index in
                            Button {
                                envModel.nowMatching = envModel.matchSort[index]
                                envModel.nowShipper = envModel.members[index]
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("\(envModel.members[index].company)：\(envModel.members[index].name)")
                            }
                        }
                    }
                }
                Button(action: {}, label: {
                    Text("アカウントの情報確認")
                })
                Button(action: {
                    envModel.deleteUserDefaults()
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
    SettingsSheet().environmentObject(EnvModel())
}
