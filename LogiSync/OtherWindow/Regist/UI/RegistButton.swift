//
//  RegistButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistButton: View {
    @State var isAlert = false
    var body: some View {
        Button(action: {
            // 送信前の確認アラート
            isAlert.toggle()
        }, label: {
            Text("登録")
        }).buttonStyle(BorderedButtonStyle())
            .alert("警告", isPresented: $isAlert) {
                Button("送信") {
                    
                }
                Button(role: .cancel) {
                    
                } label: {
                    Text("戻る")
                }
            } message: {
                Text("送信してもよろしいですか？")
            }
    }
}

#Preview {
    RegistButton()
}
