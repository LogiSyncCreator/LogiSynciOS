import SwiftUI
import SwiftData

struct ChatInputView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @Binding var editText: String
    
    @FocusState private var focus: Bool
    
//    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var mVASpeech: VASpeech
    @ObservedObject var msgViewModel: MsgChangeViewModel
    
//    let currentUser: MyUser
//    let room: Rooms
    
    @State private var isSheet = false
    @State private var isChat = false
    @State private var isVoice = false
    
    
    
    var body: some View {
        
        VStack{
           
            VStack {
                HStack(spacing: 5){
                    Spacer(minLength: 0)
                    VStack{
                        if isVoice {
                            HStack {
                                Text("")
                                    .frame(width: 10, height: 10)
                                    .background(.red)
                                    .cornerRadius(10)
                                Text("レコーディング中")
                                    .font(.title3)
                                
                                
                                Image(systemName: "waveform")
                                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing)
                                    .font(.title)
                                
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                        } else {
                            
                            if isChat {
                                VStack(alignment: .leading){
                                    Button {
                                        isChat = false
                                        isSheet = true
                                    } label: {
                                        HStack{
                                            Image(systemName: "arrow.uturn.left")
                                            Text("戻る")
                                        }
                                    }
                                    
                                    TextField("メッセージを入力", text: $editText, axis: .vertical)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        //.ignoresSafeArea(.keyboard, edges: .bottom)
                                        .font(.title)
                                        .focused($focus)
                                }
                                
                            } else {
                                Button{
                                    //action
                                    isSheet = true
                                } label: {
                                    Text("メッセージを入力")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        
                    }
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    //マイクボタン or 送信ボタン
                    VStack{
                        Spacer()
                        if editText == "" {
                            Button{
                                //aciton
                                //ボイスを送ります
                                if(mVASpeech.isFinal){
                                    //開始
                                    mVASpeech.startRecording()
                                    isVoice = true
                                } else {
                                    isVoice = false
                                    
                                    Task {
                                        //停止
                                        let txt = try await mVASpeech.stopRecording()
                                        
                                        
                                        if txt != "" {
                                            //viewModel.sendMessage(message: txt, user: user, createAt: Date(), group: group)
                                            editText = txt
                                            isChat = true
                                        }
                                        
                                    }
                                }
                            } label: {
                                
                                if(mVASpeech.isFinal){
                                    //開始
                                    
                                    Image(systemName: "mic")
                                        .resizable()
                                        .frame(width: 30, height: 40)
                                        .foregroundStyle(.white)
                                    
                                    
                                }
                                else {
                                    //停止
                                    Image(systemName: "mic.fill")
                                        .resizable()
                                        .frame(width: 30, height: 40)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(width: 70, height: 70)
                            .background(.blue)
                            .clipShape(Circle())
                        } else {
                            Button{
                                //action
                                //ここで送信の処理
//                                chatViewModel.sendAndInsert(mc: modelContext ,matchingsId: room.matchingsId, sendUserId: currentUser.user.id, message: editText, sendUserName: currentUser.user.name, role: currentUser.user.role)
                                
                                editText = ""
                                
                                //シミュレーターでは挙動がバグるため、以下を設定している
                                isChat = false
                            } label: {
                                Image(systemName: "paperplane")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 70, height: 70)
                            .background(.blue)
                            .clipShape(Circle())
                        }
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 3)
                .sheet(isPresented: $isSheet) {
                    QuickMessageView(editText: $editText, isChat: $isChat, focus: $focus, msgViewModel: msgViewModel)
                        .presentationContentInteraction(.resizes)
                        .presentationDetents([.medium, .large])
                        .presentationContentInteraction(.scrolls)
                        .presentationDragIndicator(.hidden)
                    
                }
            }
            
        }
        
        
    }
}
