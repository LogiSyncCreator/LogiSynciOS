//
//  TextFieldView.swift
//  SampleChat
//
//  Created by 中島瑠斗 on 2024/07/09.
//

import SwiftUI

struct TextFieldView: View {
    @EnvironmentObject var environVM: EnvironmentViewModel
    @EnvironmentObject var chatVM: ChatListViewModel
    @State var index: Int
    @State var width: CGFloat = 48
    @State var uiImage: UIImage? = nil
    @State var role: String = ""
    
//    @ObservedObject var viewModel: ChatViewModel
//    var currentUser: MyUser// 誰が送っているのかを判断するため
//    let room: Rooms
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(chatVM.chats.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 8) {
                            //currentUserとuserが同じかどうかでメッセージをどっちから表示させるか判定
                            if chatVM.chats[index].sendUserId == environVM.model.account.user.userId {
                                Spacer()
                                MessageView(message: chatVM.chats[index].sendMessage)
                                    .id(index)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 250, alignment: .trailing) //ここを数値指定しない方法を模索
                            } else {
    //                            CircleProfileUI(userIcon: currentUser.user.role, size: .small)
                                    /*.overlay(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                                        StatusIconUI(status: message.user.status)
                                    }*/
                                UserThumbnailUI(width: $width, uiImage: $uiImage, userRole: $role).onAppear(){
                                    // ユーザーサムネの判定
                                    if environVM.model.account.user.role == "運転手" {
                                        role = "荷主"
                                    } else {
                                        role = "運転手"
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 3){
                                    Text("\(chatVM.chats[index].userName)")
                                        .font(.caption)
                                        
                                        
                                    MessageView(message: chatVM.chats[index].sendMessage)
                                        .id(index)
                                        .frame(maxWidth: 250, alignment: .leading) //ここを数値指定しない方法を模索
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .onAppear(){
                    if let lastChatIndex = chatVM.chats.indices.last {
                        proxy.scrollTo(lastChatIndex, anchor: .bottom)
                    }
                }
                .onChange(of: chatVM.chats.indices) {
                    if let lastChatIndex = chatVM.chats.indices.last {
                        proxy.scrollTo(lastChatIndex, anchor: .bottom)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)//スクロールをしたらキーボードが消える
    }
}


//#Preview {
//    @State var room = Rooms(id: "1", matchingsId: "1", driverId: "1", shipperId: "", managerId: "a", roomName: "架空株式会社")
//    @State var user = MyUser()
//    @State var flag = false
//    return ChatView(room: $room, currentUser: user, chatViewModel: ChatViewModel(), mVASpeech: VASpeech(), isFlag: $flag)
//}
