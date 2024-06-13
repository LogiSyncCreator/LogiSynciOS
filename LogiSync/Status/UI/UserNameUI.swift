//
//  UserNameUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

// 名札
struct UserNameUI: View {
    // 必要に応じてAppStorage
    @Binding var name: String
    @Binding var group: String
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(name).font(.title).bold().lineLimit(1)
                Text(group).font(.title2).lineLimit(2)
            }
        }
    }
}
