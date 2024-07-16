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
    @EnvironmentObject var environVM: EnvironmentViewModel
    @ObservedObject var mVASpeech: VASpeech
    @State var index: Int
    @State var title: String = ""
    
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
        NavigationStack{
            ZStack{
                VStack{
                    TextFieldView(index: index).onTapGesture {
                        focus = false
                    }.layoutPriority(1)
                    ChatInputView(editText: $editText, mVASpeech: mVASpeech, msgViewModel: msgViewModel).focused($focus)
                }
                
                if mVASpeech.isLoading {
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }.frame(width: 300, height: 300)
                }
            }.navigationTitle("\(title)")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink(destination: MsgChangeView(viewModel: msgViewModel)){
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundStyle(Color(.label))
                        }
                    }
                }
        }
        .onAppear(){
            
            if environVM.model.account.user.role == "運転手" {
                title = environVM.model.matchings[index].user.shipper.company
            } else {
                title = environVM.model.matchings[index].user.driver.company
            }
            
        }
    }
}
