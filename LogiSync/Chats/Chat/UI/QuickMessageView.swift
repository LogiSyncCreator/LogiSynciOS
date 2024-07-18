//
//  QuickMessageView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import Foundation
import SwiftData
import SwiftUI

struct QuickMessageView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @EnvironmentObject var environVM: EnvironmentViewModel
    @EnvironmentObject var chatVM: ChatListViewModel
    @State var matchingId: String
    @Binding var receivedId: String
    
    @Environment(\.dismiss) private var dismiss
    @Binding var editText: String
    @Binding var isChat: Bool
    
    var focus: FocusState<Bool>.Binding
    
//    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var msgViewModel: MsgChangeViewModel
    
    
//    let currentUser: MyUser
//    let room: Rooms
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        VStack{
            
            Spacer(minLength: 10)
            //チャット入力画面へ
            Button{
                //action
                isChat = true
                dismiss()
                focus.wrappedValue = true
            } label: {
                Text("キーボード入力")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                
                
            }
            
            ScrollView(showsIndicators: false){
                GeometryReader { geometry in
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach($msgViewModel.quickMessages) { $message in
                            
                            Button{
                                //ここを送信にする
                                editText = message.message
                                
                                //ここで送信の処理
                                Task {
                                    try await chatVM.sendMessage(matchingId: matchingId, sendUserId: environVM.model.account.user.userId, sendMessage: editText)
                                    try await chatVM.api.sendUserMessage(user: receivedId, message: "\(environVM.model.account.user.company) \(environVM.model.account.user.name)\n\(editText)")
                                    await MainActor.run {
                                        //カウントアップ
                                        msgViewModel.countUp(messageId: message.id)
                                        editText = ""
                                        dismiss()
                                    }
                                }
                                
//                                chatViewModel.sendAndInsert(mc: modelContext ,matchingsId: room.matchingsId, sendUserId: currentUser.user.id, message: editText, sendUserName: currentUser.user.name, role: currentUser.user.role)
                                
                            } label: {
                                Text(message.message)
                                    .padding()
                                    .frame(width: geometry.size.width / 2)
                                    .background(Color.gray.opacity(0.4))
                                    .cornerRadius(8)
                                    .foregroundStyle(Color(.label))
                            }
                            
                            
                            
                        }
                        
                    }
                }.frame(height: 500) // レイアウトの問題を解決
                
            }
        }
        .padding(.horizontal, 3)
        
    }
}
