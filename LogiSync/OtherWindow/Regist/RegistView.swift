//
//  RegistView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistView: View {
    
    @StateObject var registVM = RegistViewModel()
    
    // ViewState
    @State var fontColor: Color = Color(.label)
    @FocusState var companyCodeFieldFocus: Bool
    @State var isShowCheck: Bool = false
    @Binding var index: Int
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("新規アカウント作成").font(.title).padding().bold()
                    
                    // 氏名
                    RegistTextField(title: "氏名", titleKey: "田中 太郎", text: $registVM.model.userName).id("氏名")
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "氏名")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    RegistTextField(title: "会社名", titleKey: "株式会社HAL", text: $registVM.model.company).id("会社名")
                    
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "会社名")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    // 役割
                    HStack{
                        Text("役割")
                        RolePicker(selectedRole: $registVM.model.selectedRole, fontColor: $fontColor)
                    }.padding()
                    
                    
                    
                    // ID
                    RegistTextField(title: "ID", titleKey: "メールアドレス、社員番号", text: $registVM.model.userId).id("id")
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "id")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    // PASS
                    Text("パスワード")
                        .padding([.top, .leading])
                    SecureField("パスワード", text: $registVM.model.userPass).id("pass").padding(.horizontal)
                    Divider().padding([.horizontal, .bottom])
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "pass")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    
                    // 連絡先・携帯番号
                    Text("連絡先・携帯番号")
                        .padding([.top, .leading])
                    TextField("00000000000", text: $registVM.model.userPhone).keyboardType(.phonePad).padding(.horizontal).id("phone")
                    Divider().padding([.horizontal, .bottom])
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "phone")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    Text("プロフィール")
                        .padding([.top, .leading])
                    RegistTextEditor(text: $registVM.model.userProfile, placeholderString: registVM.model.userProfile).padding([.leading, .bottom]).id("profile")
                    if isShowCheck {
                        Text(registVM.inputCheck(check: "profile")).foregroundStyle(.red).padding(.leading)
                    }
                    
                    HStack{
                        Spacer()
                        RegistButton(registVM: registVM, isShowCheck: $isShowCheck, index: $index)
                        Spacer()
                    }
                    Spacer().frame(height: 300)
                }
            }
        })
    }
}

//#Preview {
//    RegistView()
//}
