//
//  ChatBarUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import SwiftUI

struct ChatBarUI: View {
    
    @EnvironmentObject var environVM: EnvironmentViewModel
    @State var uiImage: UIImage? = nil
    @State var width: CGFloat = 60
    @State var index: Int
    
    @State var role: String = ""
    @State var company: String = ""
    
    var body: some View {
        VStack{
            HStack{
                UserThumbnailUI(width: $width, uiImage: $uiImage, userRole: $role).onAppear(){
                    // ユーザーサムネの判定
                    if environVM.model.account.user.role == "運転手" {
                        role = "荷主"
                    } else {
                        role = "運転手"
                    }
                }
                
                VStack(alignment: .leading){
                    Text(company).font(.headline).onAppear(){
                        // 会社名の判定
                        if environVM.model.account.user.role == "運転手" {
                            company = environVM.model.matchings[index].user.shipper.company
                        } else {
                            company = environVM.model.matchings[index].user.driver.company
                        }
                    }
                }.padding(.horizontal, 5)
                
                Spacer()
            }.foregroundStyle(Color(.label))
                .padding()
            Divider()
        }
    }
}
