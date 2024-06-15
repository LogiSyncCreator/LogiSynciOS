//
//  LoginView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import SwiftUI

struct LoginView: View {
// 参考サイト
// https://zenn.dev/usk2000/articles/6a1f6a6f3d6b4917addc
    
    // Model
    @State var userId: String = ""
    @State var userPass: String = ""
    
    @State var isOpen: Bool = false
    
    @Binding var index: Int
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("logisync").textCase(.uppercase).font(.largeTitle).bold()
            }
            VStack{
                TextField("ID", text: $userId)
                Divider().padding(.vertical)
                SecureField("パスワード", text: $userPass)
                Divider()
            }.padding()
            VStack{
                HStack {
                    Button(action: {
                        // シートを開く
                        isOpen.toggle()
                    }, label: {
                        Text("新規作成").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.trailing).bold()
                    
                    Button(action: {
                        // ログイン処理
                        withAnimation {
                            index = 0
                        }
                    }, label: {
                        Text("ログイン").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).bold()
                    }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.leading)
                }
            }.sheet(isPresented: $isOpen, content: {
                Text("新規作成画面")
            })
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
