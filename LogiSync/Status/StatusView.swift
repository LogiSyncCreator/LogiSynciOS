//
//  StatusView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusView: View {
    
    @EnvironmentObject var envModel: EnvModel

    // 対象のユーザーのステータス
    // ピッカーに合わせて切り替える
    // VMで変更
    @State var account = StatusTestData().driverAccount
    
    // 受信して変化するユーザーステータス
    @State var nowStatus = CustomStatus(id: "", name: "", color: "", icon: "", manager: "", shipper: "", delete: false, index: 0)
    // 受信して変化するUIステータス
    // ステータス
    @State var statusModel = StatusTestData().StatusTagData
    
    // UIステータス
    @State var rollFontColor: Color = Color(.label)
    @State var thumbWidth: CGFloat = 100
    @State var thumbStatusIconWidth: CGFloat = 40
    @State var selectedRole: String = ""
    
    
    var body: some View {
        VStack{
            HStack{
                SettingButtonUI()
                Spacer()
                // ここのピッカーの値変更で表示を切り替えできるようにする
                RolePicker(selectedRole: $selectedRole, fontColor: $rollFontColor).onAppear(){
                    selectedRole = envModel.user.role
                }.onChange(of: envModel.user.name) {
                    selectedRole = envModel.user.role
                }.disabled(envModel.nowMatching.id.isEmpty)
            }.padding()
            Divider()
            HStack{
                UserThumbnailUI(width: $thumbWidth, uiImage: $account.uiimage).overlay(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                    if selectedRole == envModel.user.role {
                        StatusIconUI(symboleColor: $envModel.nowStatus.color, symbole: $envModel.nowStatus.icon, width: $thumbStatusIconWidth)
                    } else {
                        StatusIconUI(symboleColor: $envModel.selectedMenberStatus.color, symbole: $envModel.selectedMenberStatus.icon, width: $thumbStatusIconWidth)
                    }
                }
                UserNameUI(name: selectedRole == envModel.user.role ? $envModel.user.name : $envModel.nowShipper.name, group: selectedRole == envModel.user.role ? $envModel.user.company : $envModel.nowShipper.company).padding(.leading)
                Spacer()
            }.padding()
            Divider()
            ProfileUI(profile: selectedRole == envModel.user.role ? $envModel.user.profile : $envModel.nowShipper.profile)
            StatusList(statusModel: $statusModel, myStatus: $nowStatus, selectedRole: $selectedRole).disabled(selectedRole != envModel.user.role)
        }
    }
}

#Preview {
    StatusView().environmentObject(EnvModel())
}
