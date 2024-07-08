//
//  RegistButton.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistButton: View {
    @EnvironmentObject var environVM: EnvironmentViewModel
    
    @StateObject var registVM: RegistViewModel
    @State var isAlert = false
    @Binding var isShowCheck: Bool
    @Binding var index: Int
    
    @State var isResultAlert: Bool = false
    @State var isCompleted: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        Button(action: {
            // 送信前の確認アラート
            self.registCheck()
            
            if registVM.proxyID.isEmpty {
                isAlert.toggle()
            } else {
                isShowCheck = true
            }
        }, label: {
            Text("登録")
        }).buttonStyle(BorderedButtonStyle())
            .alert("警告", isPresented: $isAlert) {
                Button("送信") {
                    let newUser = UserInformation(id: "", userId: registVM.model.userId, profile: registVM.model.userProfile, name: registVM.model.userName, company: registVM.model.company, role: registVM.model.selectedRole, phone: registVM.model.userPhone)
                    Task{
                        do {
                            try await APIRequests().registUser(registUser: newUser, pass: registVM.model.userPass)
                            await MainActor.run {
                                self.isCompleted = true
                            }
                        } catch {
                            await MainActor.run {
                                self.isResultAlert = true
                            }
                        }
                    }
                }
                Button(role: .cancel) {
                    
                } label: {
                    Text("戻る")
                }
            } message: {
                Text("送信してもよろしいですか？")
            }
            .alert("警告", isPresented: $isResultAlert){
                Button("OK"){
                    dismiss()
                }
            } message: {
                Text("IDが使用ずみ、もしくはサーバーエラーです。")
            }
            .alert("成功", isPresented: $isCompleted){
                Button("OK"){
                    Task {
                        do {
                            // 新処理
                            try await environVM.login(userId: registVM.model.userId, pass: registVM.model.userPass)
                            
                            if !environVM.model.account.user.userId.isEmpty {
                                // ログイン処理
                                withAnimation {
                                    index = 0
                                }
                            }
                            
                        } catch {
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("アカウントの作成が完了しました。")
            }
    }
    
    func registCheck(){
        let check = ["profile","コード","id","pass","phone","氏名"]
        for name in check {
           registVM.inputCheck(checkId: name)
        }
    }
    
}
