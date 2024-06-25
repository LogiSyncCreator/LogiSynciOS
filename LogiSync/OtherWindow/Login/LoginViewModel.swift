//
//  LoginViewModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    func login(id: String, pass: String) async throws -> Data {
        
        let postData: [String: Any] = [
            "username" : id, "password" : pass
        ]
        
        guard let url = URL(string: "\(APIManager().host)/accounts/login") else {
            throw URLError(.badURL)
        }
        
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // POSTデータを設定
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        return data
        
    }
    
}
