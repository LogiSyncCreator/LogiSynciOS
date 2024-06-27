//
//  StatusList.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusList: View {
    @EnvironmentObject var envModel: EnvModel
    @Binding var statusModel: [StatusTagModelTest] // 本番環境に合わせて変更する
    @State var width: CGFloat = 30          // デフォルトサイズ
//    @Binding var myStatus: StatusTagModelTest   // 現在のステータス
    @Binding var myStatus: CustomStatus
    
    @Binding var selectedRole: String
    
    var body: some View {
        List {
            ForEach(envModel.statusList.indices, id: \.self){ index in
                Button(action: {
                    // 処理を書く
//                    myStatus = statusModel[index]
//                    envModel.nowStatus = envModel.statusList[index]
//                    envModel.statusData.name = envModel.statusList[index].name
                    
//                    Task {
//                        print()
                    
                    envModel.statusData.name = envModel.statusList[index].name
                    
                    Task {
                        try await APIManager().sendNotificationStatus(host: envModel.user.userId, receiver: envModel.nowShipper.userId, status: envModel.statusData.name)
                    }
                    
//                    Task {
//                        try await APIManager().sendRequest(param: "\(envModel.user.userId)/\(envModel.statusList[index].name)", endPoint: "/status/setStatus/")
//                        try await envModel.setNowStatus()
//                        print(envModel.nowStatus.name)
//                    }
//                    }
                    
                }, label: {
                    HStack{
//                        StatusIconUI(symboleColor: $statusModel[index].symboleColor, symbole: $statusModel[index].symbole, width: $width)
                        StatusIconUI(symboleColor: $envModel.statusList[index].color, symbole: $envModel.statusList[index].icon, width: $width)
                        Text(envModel.statusList[index].name).foregroundStyle(envModel.user.role == selectedRole ? Color(.label) : Color.gray)
//                        Text(envModel.statusList[index].name).foregroundStyle( Color.gray)
                    }
                })
            }
        }.scrollContentBackground(.hidden).onAppear(){
            print(self.envModel.matching.count)
        }
    }
}
