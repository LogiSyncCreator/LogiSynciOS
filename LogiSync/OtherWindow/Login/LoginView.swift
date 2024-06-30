//
//  LoginView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import SwiftUI

struct LoginView: View {
// 参考サイト Combine
// https://zenn.dev/usk2000/articles/6a1f6a6f3d6b4917addc
    
    @StateObject var loginVM = LoginViewModel()
    @EnvironmentObject var envModel: EnvModel
    @EnvironmentObject var environVM: EnvironmentViewModel
    
    // Model
    @AppStorage ("userId") var userId: String = ""
    @AppStorage ("userPass") var userPass: String = ""
    
    // UI
    @State var error: Bool = false
    @FocusState var isFocus1: Bool
    @FocusState var isFocus2: Bool
    
    // ViewState
    @State var isSheet: Bool = true
    @State var isOpen: Bool = false
    @Binding var index: Int
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("logisync").textCase(.uppercase).font(.largeTitle).bold()
            }
            VStack{
                TextField("ID", text: $userId).focused($isFocus1)
                Divider().padding(.vertical)
                SecureField("パスワード", text: $userPass).focused($isFocus2)
                Divider()
            }.padding()
            VStack{
                HStack {
                    Button(action: {
                        // シートを開く
//                        isOpen.toggle()
                        // ログイン処理
                        withAnimation {
                            index = 0
                            isFocus1 = false
                            isFocus2 = false
                        }
                    }, label: {
                        Text("新規作成").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.trailing).bold()
                    
                    
//                    NavigationLink {
//                        ScrollView {
//                            VStack{
//                                RegistView().interactiveDismissDisabled(isSheet)
//                            }.onAppear(){
//                                
//                            }
//                        }.scrollDismissesKeyboard(.immediately)
//                    } label: {
//                        Text("新規作成").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
//                    }.background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.trailing).bold()

                    
                    Button(action: {
                        // 使用例
                        Task {
                            do {
                                
                                // 旧処理
//                                let response = try await loginVM.login(id: userId, pass: userPass)
//                                
//                                envModel.setUser(json: response)
                                
                                // 新処理
                                try await environVM.login(userId: userId, pass: userPass)
                                
                                if !environVM.model.account.user.userId.isEmpty {
                                    // ログイン処理
                                    withAnimation {
                                        index = 0
                                        isFocus1 = false
                                        isFocus2 = false
                                    }
                                }
                                
                            } catch {
                                print("Error: \(error.localizedDescription)")
                                self.error = true
                                
                            }
                        }
                        
                    }, label: {
                        Text("ログイン").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).bold()
                    }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.leading)
                }
                if error {
                    HStack{
                        Text("ログインに失敗しました").foregroundStyle(.red)
                        Spacer()
                    }.padding()
                }
            }.sheet(isPresented: $isOpen, content: {
                ScrollView {
                    VStack{
                        RegistView().interactiveDismissDisabled(isSheet)
                    }
                }.scrollDismissesKeyboard(.immediately)
            })
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
