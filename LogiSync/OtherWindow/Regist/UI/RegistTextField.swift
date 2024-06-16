//
//  RegistTextField.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistTextField: View {
    @State var titleKey: String = "氏名"
    @State var text: String = ""
    var body: some View {
        VStack{
            TextField(titleKey, text: $text)
            Divider()
        }
    }
}

#Preview {
    RegistTextField()
}
