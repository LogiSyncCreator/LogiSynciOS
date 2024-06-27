//
//  ProfileUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import SwiftUI

struct ProfileUI: View {
    @Binding var profile: String
    @State var isOpen: Bool = true
    @State var textHeight: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading){
            Text(profile).lineLimit(isOpen ? nil : 2).padding(.horizontal)
                .background(
                    GeometryReader(content: { geometry in
                        Color.clear.onAppear(){
                            self.textHeight = geometry.size.height
                        }
                    })
                )
            if textHeight > 35 {
                HStack{
                    Spacer()
                    Button("プロフィールを\(isOpen ? "縮小" : "展開")する"){
                        withAnimation{
                            isOpen.toggle()
                        }
                    }.foregroundStyle(.cyan).padding(.trailing, 5)
                }.onAppear(){
                    isOpen = false
                }
            }
            
            Divider()
        }
    }
}
