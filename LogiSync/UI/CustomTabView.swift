//
//  CustomTabView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/15.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var index: Int
    var body: some View {
        VStack{
        Spacer()
        HStack{
            Spacer()
            Button {
                withAnimation{
                    if index != 3 {
                        index = 0
                    }
                }
            } label: {
                VStack{
                    Image(systemName: "person.fill").font(.title)
                    Text("ステータス").font(.caption)
                }.frame(width: 100)
            }
            Spacer()
            Button {
                withAnimation{
                    if index != 3 {
                        index = 1
                    }
                }
            } label: {
                VStack{
                    Image(systemName: "location.fill").font(.title)
                    Text("位置共有").font(.caption)
                }.frame(width: 100)
            }
            Spacer()
            Button {
                withAnimation{
                    if index != 3 {
                        index = 2
                    }
                }
            } label: {
                VStack{
                    Image(systemName: "person.fill").font(.title)
                    Text("連絡").font(.caption)
                }.frame(width: 100)
            }
            Spacer()
        }.padding(.top, 5).background(Material.bar)
    }
    }
}
