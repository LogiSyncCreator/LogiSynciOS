//
//  StatusList.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusList: View {
    
    @Binding var statusModel: [StatusTagModelTest] // 本番環境に合わせて変更する
    @State var width: CGFloat = 30          // デフォルトサイズ
    @Binding var myStatus: StatusTagModelTest   // 現在のステータス
    
    var body: some View {
        List {
            ForEach(statusModel.indices, id: \.self){ index in
                Button(action: {
                    // 処理を書く
                    myStatus = statusModel[index]
                }, label: {
                    HStack{
                        StatusIconUI(symboleColor: $statusModel[index].symboleColor, symbole: $statusModel[index].symbole, width: $width)
                        Text(statusModel[index].label).foregroundStyle(Color(.label))
                    }
                })
            }
        }.scrollContentBackground(.hidden)
    }
}
