//
//  StatusView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var environVM: EnvironmentViewModel
    
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
    @State var selectedRole: String = "運転手"
    
    @Binding var viewIndex: Int
    
    
    var body: some View {
        VStack{
            HStack{
                SettingButtonUI(viewIndex: $viewIndex)
                Spacer()
                // ここのピッカーの値変更で表示を切り替えできるようにする
                RolePicker(selectedRole: $selectedRole, fontColor: $rollFontColor).onAppear(){
                    selectedRole = environVM.model.account.user.role
                }.onChange(of: environVM.model.account.user.name) {
                    selectedRole = environVM.model.account.user.role
                }.disabled(environVM.model.nowMatching == -1)
            }.padding()
            Divider()
            HStack{
                UserThumbnailUI(width: $thumbWidth, uiImage: $account.uiimage, userRole: $selectedRole).overlay(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                    if selectedRole == environVM.model.account.user.role {
                        StatusIconUI(symboleColor: $environVM.model.account.status.color, symbole: $environVM.model.account.status.icon, width: $thumbStatusIconWidth)
                    } else {
                        StatusIconUI(symboleColor: $environVM.model.nowMatchingUser.status.color, symbole: $environVM.model.nowMatchingUser.status.icon, width: $thumbStatusIconWidth)
                    }
                }
                UserNameUI(name: selectedRole == environVM.model.account.user.role ? $environVM.model.account.user.name : $environVM.model.nowMatchingUser.user.name, group: selectedRole == environVM.model.account.user.role ? $environVM.model.account.user.company : $environVM.model.nowMatchingUser.user.company).padding(.leading)
                Spacer()
            }.padding()
            Divider()
            ProfileUI(profile: selectedRole == environVM.model.account.user.role ? $environVM.model.account.user.profile : $environVM.model.nowMatchingUser.user.profile)
            StatusList(statusModel: $statusModel, selectedRole: $selectedRole).disabled(selectedRole != environVM.model.account.user.role)
        }
    }
}

//#Preview {
//    StatusView().environmentObject(EnvironmentViewModel())
//}
