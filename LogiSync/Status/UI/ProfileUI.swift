//
//  ProfileUI.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

//import SwiftUI
//
//struct ProfileUI: View {
//    @Binding var profile: String
//    @State var isOpen: Bool = false
//    @State var textHeight: CGFloat = 0
//    var body: some View {
//        VStack(alignment: .leading){
//            Text(profile).lineLimit(isOpen ? nil: 20).padding(.horizontal)
//                .background(
//                    GeometryReader(content: { geometry in
//                        Color.red.onAppear(){
//                            self.textHeight = geometry.size.height.binade
//                            print(self.textHeight)
//                        }
//                    })
//                )
//            if textHeight > 13 {
//                HStack{
//                    Spacer()
//                    Button("プロフィールを\(isOpen ? "縮小" : "展開")する"){
//                        withAnimation{
//                            isOpen.toggle()
//                        }
//                    }.foregroundStyle(.cyan).padding(.trailing, 5)
//                }.onAppear(){
//                    isOpen = false
//                }
//            }
//            
//            Divider()
//        }
//    }
//}

import SwiftUI

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ProfileUI: View {
    @Binding var profile: String
    @State private var isOpen: Bool = true
    @State private var textHeight: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(isOpen ? profile : String(profile.prefix(30)) + "...")
                .lineLimit(nil).padding(.horizontal)
            
            HStack{
                Spacer()
                if profile.count > 30 {
                    Button(action: {
                        withAnimation {
                            isOpen.toggle()
                        }
                    }) {
                        Text(isOpen ? "折りたたむ" : "続きを読む")
                            .foregroundColor(.blue)
                    }.onAppear(){
                        isOpen.toggle()
                    }
                }
            }.padding(.trailing)
            
            Divider()
        }
    }
}
