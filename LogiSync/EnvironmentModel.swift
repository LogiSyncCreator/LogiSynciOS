//
//  EnvironmentModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/28.
//

import Foundation

struct EnvironmentModel {
    var account: MyUser = MyUser()
    var statusList: [CustomStatus] = []
    var matchings: [MyMatching] = []
    var nowMatching: Int = -1
    var nowMatchingUser: MyUser = MyUser()
    
    let api = APIRequests()
    
    
    /// ログインしてステータスをセットする
    /// - ログイン処理:
    ///   - id: user id
    ///   - pass: user password
    func getUserInfo(id: String, pass: String) async throws -> UserInformation {
        do {
            let user = try await api.userLogin(id: id, pass: pass)
            let userInfo = try JSONDecoder().decode(UserInformation.self, from: user)
            return userInfo
        } catch {
            print("Invalid user id or password.")
            return UserInformation()
        }
    }
    
    /// ステータスを取得する
    func getUserStatus() async throws -> UserStatus {
        do {
            let status = try await api.getStatus(id: account.user.userId)
            let userStatus = try JSONDecoder().decode(UserStatus.self, from: status)
            return userStatus
        } catch {
            print("Invalid user id.")
            return UserStatus()
        }
    }
    
    func retrieveDefaultStatus() async throws -> [CustomStatus] {
        do {
            let defaultStatusListData = try await api.getStatusList(managerId: "all", shipperId: "all")
            let defaultStatusList = try JSONDecoder().decode([CustomStatus].self, from: defaultStatusListData)
            return defaultStatusList
        } catch {
            print("Not found status list.")
            return []
        }
    }
    
    func retriveMatchngGroup(postData: [String: Any]) async throws -> [MyMatching] {
        do {
            let matchingData = try await api.getMatchingGroup(postData: postData)
            let matchings = try JSONDecoder().decode([MyMatching].self, from: matchingData)
            return matchings
        } catch {
            print("Not Found matching list.")
            return []
        }
    }
    
    func retriveMatchingStatus(managerId: String, shipperId: String) async throws -> [CustomStatus] {
        do {
            let statusListData = try await api.getStatusList(managerId: managerId, shipperId: shipperId)
            let statusList = try JSONDecoder().decode([CustomStatus].self, from: statusListData)
            return statusList
        } catch {
            print("Not found matching User Patern")
            return []
        }
    }
    
    func retriveMatchingUserStatus(userId: String) async throws -> UserStatus {
        do {
            let status = try await api.getStatus(id: userId)
            return try JSONDecoder().decode(UserStatus.self, from: status)
        } catch {
            print("Invalid user id.")
            return UserStatus()
        }
    }
    
    func updateMyStatus(userId: String, statusId: String) async throws -> UserStatus {
        do {
            let nowStatusData = try await api.updateMyStatus(userId: userId, statusId: statusId)
            let nowStatus = try JSONDecoder().decode(UserStatus.self, from: nowStatusData)
            return nowStatus
        } catch {
            print("StatusId or UserId is invalid.")
            return UserStatus()
        }
    }
    
    func checkMyToken() async throws {
        do {
            let key = "token"
            guard let token = UserDefaults.standard.string(forKey: key) else { return }
            try await api.checkToken(token: UserToken(userId: self.account.user.userId, token: token))
        } catch {
            print("token is invalid.")
        }
    }
}

struct MyUser {
    var user: UserInformation = UserInformation()
    var status: UserStatus = UserStatus()
}

struct MyMatching: Codable {
    var index: Int = 0
    var matching: MatchingInformation = MatchingInformation()
    var user: MatchingUser = MatchingUser(manager: UserInformation(), shipper: UserInformation(), driver: UserInformation())
}

struct UserInformation: Codable {
    var id: String = ""
    var userId: String = ""
    var profile: String = ""
    var name: String = ""
    var company: String = ""
    var role: String = ""
    var phone: String = ""
}

struct UserStatus: Codable {
    var id: String = ""
    var userId: String = ""
    var statusId: String = ""
    var name: String = ""
    var color: String = ""
    var icon: String = ""
    var delete: Bool = false
}

struct MatchingInformation: Codable {
    var id: String = ""
    var manager: String = ""
    var shipper: String = ""
    var driver: String = ""
    var address: String = ""
    var start: String = ""
}

struct MatchingUser: Codable {
    var manager: UserInformation
    var shipper: UserInformation
    var driver: UserInformation
}

struct UserToken: Codable {
    var userId: String
    var token: String
}
