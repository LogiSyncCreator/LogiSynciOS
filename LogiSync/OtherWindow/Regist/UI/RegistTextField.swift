//
//  RegistTextField.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/16.
//

import SwiftUI

struct RegistTextField: View {
    @State var title: String = ""
    @State var titleKey: String = ""
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
            TextField(titleKey, text: $text)
            Divider()
        }.padding()
    }
}
