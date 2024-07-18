//
//  MsgChangeViewModel.swift
//  SampleChat
//
//  Created by 中島瑠斗 on 2024/07/09.
//

import SwiftUI

class MsgChangeViewModel: ObservableObject {
    @Published var quickMessages: [QuickMessage] {
        didSet {
            saveMessages()
        }
    }
    
    private let messagesKey = "quickMessages"
    
    init() {
        self.quickMessages = UserDefaults.standard.loadMessages(forKey: messagesKey) ?? [
            QuickMessage(message: "こんにちは", count: 0),
            QuickMessage(message: "お疲れ様です", count: 0),
            QuickMessage(message: "ありがとうございます", count: 0),
            QuickMessage(message: "おはようございます", count: 0),
            QuickMessage(message: "よろしくお願いします", count: 0),
            QuickMessage(message: "すみません、少し遅れます", count: 0),
            QuickMessage(message: "了解しました", count: 0),
            QuickMessage(message: "確認しました", count: 0),
            QuickMessage(message: "今、運転中です", count: 0),
            QuickMessage(message: "後ほどご連絡します", count: 0),
        ]
    }
    
    func addMessage(message: String) {
        if !message.isEmpty{
            quickMessages.append(QuickMessage(message: message, count: 0))
        }
    }
    
    func deleteMessage(at offsets: IndexSet) {
        quickMessages.remove(atOffsets: offsets)
    }
    
    private func saveMessages() {
        UserDefaults.standard.saveMessages(messages: quickMessages, forKey: messagesKey)
    }
    func countUp(messageId: UUID) {
        if let index = quickMessages.firstIndex(where: { $0.id == messageId }) {
            quickMessages[index].count += 1
            quickMessages.sort { $0.count > $1.count }
        }
    }
}

extension UserDefaults {
    func loadMessages(forKey key: String) -> [QuickMessage]? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            return try? decoder.decode([QuickMessage].self, from: data)
        }
        return nil
    }
    
    func saveMessages(messages: [QuickMessage], forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(messages) {
            self.set(data, forKey: key)
        }
    }
}

struct QuickMessage: Identifiable, Codable, Hashable {
    let id: UUID
    var message: String
    var count: Int
    
    init(message: String, count: Int) {
        self.id = UUID()
        self.message = message
        self.count = count
    }
}
