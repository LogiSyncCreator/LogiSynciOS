//
//  ChatView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import SwiftUI
import Speech
import SwiftData
import Combine

struct ChatView: View {
    @StateObject var mVASpeech = VASpeech()
    @State var index: Int
    
    @Environment(\.modelContext) private var modelContext
    //    @Query(sort: \Messages.creatAt) private var fetchMessages: [Messages]
    
    //    @Binding var room: Rooms
    @State var editText = ""
    @FocusState private var focus: Bool
    
//    var currentUser: MyUser
    
    //    @StateObject var chatViewModel = ChatViewModel()
    //    @ObservedObject var mVASpeech: VASpeech
    @StateObject var msgViewModel = MsgChangeViewModel()
    
    @State var isMessage: Bool = false
    
//    @Binding var isFlag: Bool
    
    
    
    //音声機能
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(){
                mVASpeech.prepareRecording()
            }
    }
}

#Preview {
    ChatView(index: 0)
}
