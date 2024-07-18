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
    //    @EnvironmentObject var envModel: EnvModel
    @StateObject var environVM: EnvironmentViewModel = EnvironmentViewModel()
    @Query private var items: [Item]
    @EnvironmentObject var locationManager:LocationManager
    @Environment(\.scenePhase) var scenePhase
    
    // 表示ページのハンドリング
    //    列挙型に変えたい
    @State var viewIndex: Int = 0
    
    var body: some View {
        ZStack{
            if viewIndex != 3 {
                switch viewIndex {
                case 0:
                    //                    ScrollView{
                    StatusView(viewIndex: $viewIndex).background(Color(.systemBackground))
                    //                    }
                    //                        .transition(.move(edge: .leading))
                case 1:
                    MapView().background(Color(.systemBackground))
                    //                        .transition(.move(edge: .leading))
                case 2:
                    ChatListView().background(Color(.systemBackground))
                    //                        .transition(.move(edge: .leading))
                default:
                    StatusView(viewIndex: $viewIndex).transition(.move(edge: .leading))
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
        }.onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .background:
                if locationManager.targetUser.user.userId.isEmpty {
                    locationManager.stopUpdatingLocation()
                }
                break
            case .inactive:
                break
            case .active:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
