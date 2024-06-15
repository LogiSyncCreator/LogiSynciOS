//
//  ContentView.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/12.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    // 表示ページのハンドリング
//    列挙型に変えたい
    @State var viewIndex: Int = 0
    
    var body: some View {
        ZStack{
            if viewIndex != 3 {
                switch viewIndex {
                case 0:
                    StatusView().background(Color(.systemBackground)).transition(.move(edge: .leading))
                case 1:
                    MapView().background(Color(.systemBackground)).transition(.move(edge: .leading))
                case 2:
                    Text("comming soon...").background(Color(.systemBackground)).transition(.move(edge: .leading))
                default:
                    StatusView().transition(.move(edge: .leading))
                }
            }
            
            if viewIndex == 3 {
                OtherContentView(index: $viewIndex).transition(.move(edge: .top))
            }
            
            if viewIndex != 3 {
                CustomTabView(index: $viewIndex).transition(.move(edge: .bottom))
            }
            
        }.onAppear(){
            // 実装時は未ログイン時に3
            // ログイン時は1
            viewIndex = 3
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
