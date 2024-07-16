//
//  APIRequests.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/28.
//

import Foundation

class APIRequests {
    //    let host: String = "192.168.211.171"
    let host: String = "192.168.68.82"
    //    wireless
    //        let host: String = "172.20.10.3"
    //    usb
    //    let host: String = "172.20.10.4"
    let port: String = "8080"
    let httpd: String = "http"
    
    func registUser(registUser: UserInformation, pass: String) async throws {
        let postData: [String: Any] = [
            "name": registUser.name,
            "company": registUser.company ,
            "role": registUser.role,
            "userId": registUser.userId,
            "pass": pass,
            "phone": registUser.phone,
            "profile": registUser.profile,
            "delete": false
        ]
        
        return try await APIRequest(postData: postData, endPoint: "accounts/regist")
        
    }
    
    func userLogin(id: String, pass: String) async throws -> Data {
        let postData: [String: Any] = ["username":id, "password":pass]
        return try await APIRequest(postData: postData, endPoint: "accounts/login")
    }
    
    func getStatus(id: String) async throws -> Data {
        return try await APIRequest(param: id, endPoint: "/status/nowstatus")
    }
    
    func getStatusList(managerId: String, shipperId: String) async throws -> Data {
        return try await APIRequest(param: "\(managerId)/\(shipperId)/", endPoint: "status/groupstatus")
    }
    
    func getMatchingGroup(postData: [String: Any]) async throws -> Data {
        return try await APIRequest(postData: postData, endPoint: "matching/group")
    }
    
    func updateMyStatus(userId: String, statusId: String) async throws -> Data {
        return try await APIRequest(param: "\(userId)/\(statusId)", endPoint: "status/setstatus")
    }
    
    func checkToken(token: UserToken) async throws {
        let postData = ["userId": token.userId, "token": token.token]
        return try await APIRequest(postData: postData, endPoint: "push")
    }
    
    func deleteToken(token: String) async throws {
        return try await APIRequest(param: token, endPoint: "deletetoken", method: "DELETE")
    }
    
    func setNowMyLocation(postData: [String: Any], matchingId: String = "") async throws {
        return try await APIRequest(postData: postData, endPoint: "locations/\(matchingId)")
    }
    
    func getUserLocation(user: String) async throws -> Data {
        return try await APIRequest(param: user, endPoint: "locations")
    }
    
    
    func deleteUserLocatio(uuid: String) async throws {
        return try await APIRequest(param: uuid, endPoint: "locations/deletemylocation", method: "DELETE")
    }
    /// pushでメッセージ
    /// - Parameters:
    ///   - user: 送り先のuser id
    ///   - message: 送る内容, そのまま表示される
    func sendUserMessage(user: String, message: String) async throws {
        return try await APIRequest(param: "\(user)/\(message)", endPoint: "push/pushmsg", method: "GET")
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: GET or DELETE
    func APIRequest(param: String, endPoint: String, method: String = "GET") async throws {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)/\(param)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // URLSessionを使用してリクエストを送信
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: POST or DELETE
    func APIRequest(postData: [String: Any], endPoint: String, method: String = "POST") async throws {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POSTデータを設定
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        
        // URLSessionを使用してリクエストを送信
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: GET or DELETE
    func APIRequest(param: String, endPoint: String, method: String = "GET") async throws -> Data {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)/\(param)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    /// Description
    /// - Parameters:
    ///   - param: http://******/{param}
    ///   - postData: ["key": value, ...]
    ///   - endPoint: http://{endpoint}/{param}
    ///   - method: POST or DELETE
    func APIRequest(postData: [String: Any], endPoint: String, method: String = "POST") async throws -> Data {
        guard let url = URL(string: "\(httpd)://\(host):\(port)/\(endPoint)") else {
            throw URLError(.badURL)
        }
        // URLRequestオブジェクトを作成
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POSTデータを設定
        request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        
        // URLSessionを使用してリクエストを送信
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // レスポンスのステータスコードをチェック
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
