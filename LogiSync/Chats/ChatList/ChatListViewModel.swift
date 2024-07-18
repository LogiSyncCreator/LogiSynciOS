//
//  ChatListViewModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/16.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    @Published var chats: [Chats] = []
    @Published var reView: Bool = false
    
    let api = APIRequests()
    
    private let key: String = "chats"
    
    private var cancellables = Set<AnyCancellable>()
    public let loadChat = PassthroughSubject<String, Never>()
    public let retrieveChat = PassthroughSubject<String, Never>()
    public let saveChat = PassthroughSubject<Void, Never>()
    
    init(){
        
        // チェックイン時にロード
        // 更新
        // セーブ
        
        // ロード
        self.loadChat.sink { matchingId in
            self.loadChats(matchingId: matchingId)
//            self.retrieveChat.send()
        }.store(in: &cancellables)
        
        // 更新用
        self.retrieveChat.sink {[weak self] matchingId in
            guard let self = self else { return }
            Task {
                do {
                    try await self.receivedMessage(matchingId: matchingId)
                    await MainActor.run {
                        self.reView.toggle()
                    }
                } catch {
                    print("APIERR: 更新失敗")
                }
            }
        }.store(in: &cancellables)
        
        // セーブ
        self.saveChat.sink { () in
            self.saveChats()
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification")).sink { Notification in
            if Notification.userInfo!["mode"] as! String == "chat" {
                
                self.retrieveChat.send(Notification.userInfo!["status"] as! String)
                
            }
        }.store(in: &cancellables)
    }
    
    
    func loadChats(matchingId: String) {
        do {
            let data = UserDefaults.standard.data(forKey: key)
            if let data = data {
                let allChats = try JSONDecoder().decode([Chats].self, from: data)
                self.chats = allChats.filter { $0.matchingId == matchingId }
            }
        } catch {
            print("chat data load error: \(error)")
        }
    }
    
    func saveChats() {
        do {
            let data = try JSONEncoder().encode(chats)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print("chat data save error.")
        }
    }
    
    func receivedMessage(matchingId: String) async throws {
        do {
            let json = try await api.getChat(matchingId: matchingId)
            try await MainActor.run {
                self.chats = try JSONDecoder().decode([Chats].self, from: json)
            }
        } catch {
            print("APIERR: チャット受信失敗")
        }
    }
    
    func sendMessage(matchingId: String, sendUserId: String, sendMessage: String) async throws {
        do {
            try await api.sendChatMessage(matchingId: matchingId, sendUserId: sendUserId, sendMessage: sendMessage)
        } catch {
            print("APIERR: チャット送信失敗")
        }
    }
    
}
