//
//  OtherContentView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import SwiftUI

struct OtherContentView: View {
    @Binding var index: Int
    var body: some View {
        VStack{
            Spacer().frame(height: 100)
            ScrollView {
                LoginView(index: $index)
            }.scrollDismissesKeyboard(.immediately)
            Spacer()
        }.background(Color(.systemBackground))
    }
}

#Preview {
    ContentView()
}
