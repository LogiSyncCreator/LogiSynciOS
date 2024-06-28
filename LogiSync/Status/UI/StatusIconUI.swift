//
//  StatusIconUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

// ステータスアイコン
struct StatusIconUI: View {
    @Binding var symboleColor: String       // アイコンの背景色
    @Binding var symbole: String        // SFシンボル
    @Binding var width: CGFloat         // サイズ
    
    var body: some View {
        ZStack{
            Circle().frame(width: width).foregroundStyle(Color(.systemBackground))
            Image(systemName: symbole.isEmpty ? "xmark.circle" : symbole).font(.system(size: width - 5)).foregroundColor(Color(symboleColor.isEmpty ? "gray" : symboleColor)).onChange(of: symboleColor) {
                print(symbole)
            }
        }
    }
}

//#Preview {
//    オフライン
//    StatusIconUI(symboleColor: Color(.systemBackground), backColor: Color(.gray), symbole: "xmark.circle", width: 30)
//    オンライン
//    StatusIconUI(symboleColor: Color(.systemBackground), backColor: Color(.green), symbole: "checkmark.circle.fill", width: 30)
    
//}
