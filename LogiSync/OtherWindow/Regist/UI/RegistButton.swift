//
//  RegistButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistButton: View {
    @StateObject var registVM: RegistViewModel
    @State var proxy: ScrollViewProxy
    @State var isAlert = false
    @Binding var isShowCheck: Bool
    
    
    var body: some View {
        Button(action: {
            // 送信前の確認アラート
            self.registCheck()
            
            if registVM.proxyID.isEmpty {
                isAlert.toggle()
            } else {
                isShowCheck = true
                proxy.scrollTo(registVM.proxyID)
            }
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
    
    func registCheck(){
        let check = ["profile","コード","id","pass","phone","氏名"]
        for name in check {
           registVM.inputCheck(checkId: name)
        }
    }
    
}
