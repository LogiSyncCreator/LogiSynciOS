//
//  RolePicker.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct RolePicker: View {
    
    @Binding var selectedRole: String
    @Binding var fontColor: Color
    
    var body: some View {
        Picker("役割", selection: $selectedRole) {
            Text("運転手").tag("運転手")
            Text("荷主").tag("荷主")
        }.pickerStyle(.menu).tint(fontColor)
    }
}
