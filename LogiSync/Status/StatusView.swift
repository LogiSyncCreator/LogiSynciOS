//
//  StatusView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct StatusView: View {

    // 対象のユーザーのステータス
    // ピッカーに合わせて切り替える
    // VMで変更
    @State var account = StatusTestData().driverAccount
    
    // 受信して変化するユーザーステータス
    @State var nowStatus = StatusTestData().StatusTagData[0]
    // 受信して変化するUIステータス
    // ステータス
    @State var statusModel = StatusTestData().StatusTagData
    
    // UIステータス
    @State var rollFontColor: Color = Color(.label)
    @State var thumbWidth: CGFloat = 100
    @State var thumbStatusIconWidth: CGFloat = 40
    
    
    var body: some View {
        VStack{
            HStack{
                SettingButtonUI()
                Spacer()
                // ここのピッカーの値変更で表示を切り替えできるようにする
                RolePicker(selectedRole: $account.selectedRole, fontColor: $rollFontColor)
            }.padding()
            Divider()
            HStack{
                UserThumbnailUI(width: $thumbWidth, uiImage: $account.uiimage).overlay(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                    StatusIconUI(symboleColor: $nowStatus.symboleColor, symbole: $nowStatus.symbole, width: $thumbStatusIconWidth)
                }
                UserNameUI(name: $account.name, group: $account.group).padding(.leading)
                Spacer()
            }.padding()
            Divider()
            ProfileUI(profile: $account.profile)
            StatusList(statusModel: $statusModel, myStatus: $nowStatus)
        }
    }
}

#Preview {
    StatusView()
}
