//
//  APIManager.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/24.
//

import Foundation

class APIManager {
    
    //  phone = 
    //  http://172.20.10.3:8080
    //  home =
    //  http://192.168.68.82:8080
    
    
    let host = "http://172.20.10.3:8080"
    
    
    // ユーザーのステータス名とタグを検索する　＊名前が一致するもの全て
    func getSearchUserStatus(param: String) async throws -> Data {
        
        let data = try await sendRequest(param: param, endPoint: "/status/searchStatus/")
        
        return data
    }
    
    // マッチングデータの取得
    func getMatching(manager: String = "", driver: String = "", shipper: String = "") async throws -> Data {
        
        let postData: [String: Any] = [
            "manager": manager,
            "driver": driver,
            "shipper": shipper,
        ]
        
        return try await sendRequest(postData: postData, endPoint: "/matching/group")
    }
    
    // 自分のステータスの取得
    // 無ければオンラインをセット
    func getNowStatus(param: String) async throws -> Data {
        do{
            return try await sendRequest(param: param, endPoint: "/status/nowstatus/")
        } catch {
            return try await sendRequest(param: "\(param)/オンライン", endPoint: "/status/setStatus/")
        }
    }
    
    // 共通ステータスの入手
    func commonStatus() async throws -> Data {
        return try await sendRequest(param: "all/all", endPoint: "/status/groupstatus/")
    }
    // マッチング内ステータスの入手
    func matchingStatus(param: String) async throws -> Data {
        return try await sendRequest(param: param, endPoint: "/status/groupstatus/")
    }
    
    // ステータスの更新
    func updateNowStatus(param: String) async throws -> Data {
        let data = try await sendRequest(param: param, endPoint: "/status/setStatus/")
        return data
    }
    
    func sendNotificationStatus(host: String, receiver: String, status: String) async throws {
        try await sendRequest(param: "\(host)/\(receiver)/\(status)", endPoint: "/push/notificationstatus/")
    }
    
    // ユーザを探す
    func searchUser(param: String) async throws -> Data {
        return try await sendRequest(param: param, endPoint: "/accounts/serchuser/")
    }
    
    // マッチング先の位置情報の取得
    func searchLocation(param: String) async throws -> Data {
        return try await sendRequest(param: param, endPoint: "/locations/")
    }
    
    
    @discardableResult
    func sendRequest(param: String, endPoint: String = "") async throws -> Data {
        
        guard let url = URL(string: "\(host)\(endPoint)\(param)") else {
            throw URLError(.badURL)
        }
        
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        return data
        
    }
    
    func sendRequest(postData: [String: Any], endPoint: String = "") async throws -> Data {
        
        guard let url = URL(string: "\(host)\(endPoint)") else {
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
