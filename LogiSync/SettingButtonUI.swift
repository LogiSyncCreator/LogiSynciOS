//
//  SettingButtonUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct SettingButtonUI: View {
    @State var isOpen: Bool = false
    var body: some View {
        Button(action: {
            isOpen.toggle()
        }, label: {
            Image(systemName: "gearshape.fill")
        }).sheet(isPresented: $isOpen, content: {
            SettingsSheet()
        })
    }
}

#Preview {
    SettingButtonUI()
}
