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
            switch viewIndex {
            case 0:
                StatusView().background(Color(.systemBackground)).transition(.move(edge: .leading))
            case 1:
                MapView().background(Color(.systemBackground)).transition(.move(edge: .leading))
            case 2:
                Text("comming soon...").background(Color(.systemBackground)).transition(.move(edge: .leading))
            case 3:
                OtherContentView(index: $viewIndex).transition(.move(edge: .top))
            default:
                StatusView().transition(.move(edge: .leading))
            }
            
            CustomTabView(index: $viewIndex)
            
        }.onAppear(){
            // 実装時は未ログイン時にTrue
            withAnimation(.easeIn){
                viewIndex = 0
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
