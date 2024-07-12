//
//  RegistTextEditor.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistTextEditor: View {
    @Binding var text: String
    @State var placeholderString: String
    
    @FocusState var isFocus: Bool
    
    var body: some View {
        TextEditor(text: $text).frame(height: 200).focused($isFocus)
            .foregroundColor(self.text == placeholderString ? .gray : .primary)
            .onTapGesture {
                if self.text == placeholderString {
                    self.text = ""
                }
            }
            .onChange(of: isFocus) {
                if !isFocus && text.isEmpty {
                    self.text = placeholderString
                }
            }
    }
}

//#Preview {
//    ScrollView{
//        RegistTextEditor(text: "氏名を入力してください", placeholderString: "氏名を入力してください")
//    }.scrollDismissesKeyboard(.immediately)
//}
