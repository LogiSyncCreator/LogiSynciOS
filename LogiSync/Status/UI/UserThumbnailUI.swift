//
//  UserThumbnailUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/13.
//

import SwiftUI

struct UserThumbnailUI: View {
        
    @Binding var width: CGFloat
    @Binding var uiImage: UIImage?
    
    var body: some View {
        ZStack{
            // サムネイル画像があれば使用する
            if let image = uiImage {
                Image(uiImage: image)
            } else {
                Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: width - 5).clipShape(Circle()).foregroundStyle(.blue)
            }
        }
    }
}
