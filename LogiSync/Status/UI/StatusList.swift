//
//  StatusList.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusList: View {
    @EnvironmentObject var envModel: EnvModel
    @EnvironmentObject var environVM: EnvironmentViewModel
    @Binding var statusModel: [StatusTagModelTest] // 本番環境に合わせて変更する
    @State var width: CGFloat = 30          // デフォルトサイズ
//    @Binding var myStatus: StatusTagModelTest   // 現在のステータス
    
    @Binding var selectedRole: String
    
    var body: some View {
        List {
            ForEach(environVM.model.statusList.indices, id: \.self){ index in
                Button(action: {
                    
//                    self.environVM.model.account.status = UserStatus(id: UUID().uuidString, userId: environVM.model.account.user.userId, statusId: environVM.model.statusList[index].id, name: environVM.model.statusList[index].name, color: environVM.model.statusList[index].color, icon: environVM.model.statusList[index].icon)
                    
                    environVM.changeStatusCalled.send(environVM.model.statusList[index])
                    
                    // 送信処理
                    
                    
                }, label: {
                    HStack{
                        StatusIconUI(symboleColor: $environVM.model.statusList[index].color, symbole: $environVM.model.statusList[index].icon, width: $width)
                        Text(environVM.model.statusList[index].name).foregroundStyle(environVM.model.account.user.role == selectedRole ? Color(.label) : Color.gray)
                    }
                })
            }
        }.scrollContentBackground(.hidden)
    }
}
