//
//  UserThumbnailUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct UserThumbnailUI: View {
    
    @EnvironmentObject var environVM: EnvironmentViewModel
    
    @Binding var width: CGFloat
    @Binding var uiImage: UIImage?
    
    var body: some View {
        ZStack{
            // サムネイル画像があれば使用する
            if let image = uiImage {
                Image(uiImage: image)
            } else {
                //                Image(systemName: environVM.model.account.user.role == "運転手" ? "truck.box" : "person.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: width - 5).clipShape(Circle()).foregroundStyle(.blue)
                Circle().frame(width: width).foregroundStyle(.blue).overlay {
                    Image(systemName: environVM.model.account.user.role == "運転手" ? "truck.box" : "person.circle.fill")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: environVM.model.account.user.role == "運転手" ? (width - 30) : (width - 5))
                        .foregroundStyle(Color("UnRapLabelColor"))
                        .scaleEffect(x: environVM.model.account.user.role == "運転手" ? -1 : 1, y: 1)
                }
            }
        }
    }
}
