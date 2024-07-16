//
//  ChatListView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var environVM: EnvironmentViewModel
    @StateObject var viewModel = ChatListViewModel()
    @StateObject var mVASpeech = VASpeech()
    //    @State var currentUser: MyUser = MyUser()
    
    @Environment(\.modelContext) private var modelContext
    //    @Query private var fetchRooms: [Rooms]
    
    @State var isOnApper = false
    
    var body: some View {
        NavigationStack {
            //            ChatListTopView() // chatのヘッダー部分
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(environVM.model.matchings.indices, id: \.self) { index in
                        NavigationLink(destination: VStack{
                            ChatView(mVASpeech: mVASpeech, index: index)
                            Spacer().frame(height: 50)
                        }) { // ChatViewというメッセージ画面に遷移
                            ChatBarUI(index: index) // chatGroupごとのデザイン
                        }
                    }
                }
            }
        }
        .onAppear {
            mVASpeech.prepareRecording()
        }
    }
}
