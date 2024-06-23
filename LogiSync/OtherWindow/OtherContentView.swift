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
//        VStack{
//            Spacer()
//            LoginView(index: $index)
//            Spacer()
//        }.background(Color(.systemBackground))
        NavigationStack {
            VStack{
                Spacer()
                LoginView(index: $index)
                Spacer()
            }.background(Color(.systemBackground)).scrollDismissesKeyboard(.immediately)
        }
    }
}

#Preview {
    ContentView()
}
