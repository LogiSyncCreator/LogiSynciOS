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
    
    private let key: String = "chats"
    
    private var cancellables = Set<AnyCancellable>()
    public let saveChat = PassthroughSubject<Void, Never>()
    public let loadChat = PassthroughSubject<Void, Never>()
    
    init(){
        self.saveChat.sink { () in
            self.saveChats()
        }.store(in: &cancellables)
        
        self.loadChat.sink { () in
            self.loadChats()
        }.store(in: &cancellables)
        
    }
    
    func saveChats() {
        do {
            let data = try JSONEncoder().encode(chats)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print("chat data save error.")
        }
    }
    
    func loadChats() {
        do {
            let data = UserDefaults.standard.data(forKey: key)
            if let data = data {
                self.chats = try JSONDecoder().decode([Chats].self, from: data)
            }
        } catch {
            print("chat data load error.")
        }
    }
    
}
