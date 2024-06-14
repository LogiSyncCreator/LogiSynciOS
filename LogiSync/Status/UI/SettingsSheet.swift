//
//  SettingsSheet.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct SettingsSheet: View {
    var body: some View {
        NavigationStack {
            List {
                Button(action: {}, label: {
                    Text("アカウントの情報確認")
                })
                Button(action: {}, label: {
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
    SettingsSheet()
}
