//
//  UserLocationSendButtonUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct UserLocationSendButtonUI: View {
    var body: some View {
        Button {
            
        } label: {
            HStack{
                Image(systemName: "mappin.circle")
                Text("送信")
            }.font(.title3).foregroundStyle(Color(.label)).padding()
        }.background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10.0))

    }
}

#Preview {
    UserLocationSendButtonUI()
}
