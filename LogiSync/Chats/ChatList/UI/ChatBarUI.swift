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
    @State var name: String = ""
    
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
                    Text(name).font(.headline).bold()
                    Text(company).font(.caption).foregroundStyle(.gray).onAppear(){
                        // 会社名の判定
                        if environVM.model.account.user.role == "運転手" {
                            company = environVM.model.matchings[index].user.shipper.company
                            name = environVM.model.matchings[index].user.shipper.name
                        } else {
                            company = environVM.model.matchings[index].user.driver.company
                            name = environVM.model.matchings[index].user.driver.name
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
