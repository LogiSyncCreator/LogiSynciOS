//
//  EnvironmentViewModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/28.
//

import Foundation
import Combine

class EnvironmentViewModel: ObservableObject {
    var model = EnvironmentModel()
    @Published var isReView: Bool = false   // 再描写用
    
    private var cancellables = Set<AnyCancellable>()
    private let loginCalled = PassthroughSubject<Void, Never>()
    public let changeStatusCalled = PassthroughSubject<CustomStatus, Never>()
    public let changeMatchingCalled = PassthroughSubject<Void, Never>()
    public let changeLogoutCalled = PassthroughSubject<Void, Never>()
    
    
    private let userDefaultKey: String = "token"
    private let tokenFlagKey: String = "tokenFlag"
    
    init() {

        loginCalled.sink { [weak self] () in
            guard let self = self else { return }
            Task{
                try await self.model.checkMyToken()
                try await self.setUserStatus()
                try await self.setMatchings()
                try await self.findStatusList(managerId: "", shipperId: "")
                await MainActor.run {
                    self.isReView.toggle()
                }
            }
        }.store(in: &cancellables)
        
        changeStatusCalled.sink { [weak self] customStatus in
//            let completed: Bool = false
            guard let self = self else { return }
            Task{
                let _ = try await self.updateUserStatus(statusId:customStatus.id)
                
//                let nowStatus = UserStatus(id: status.id, userId: status.userId, statusId: status.statusId, name: customStatus.name, color: customStatus.color, icon: customStatus.icon)
                
                await MainActor.run {
//                   self.model.account.status = nowStatus
                   self.isReView.toggle()
                }
            }
            
        }.store(in: &cancellables)
        
        changeMatchingCalled.sink { [weak self] () in
            
            guard let self = self else { return }
            
            if (self.model.account.user.role == "運転手"){
                self.model.nowMatchingUser.user = self.model.matchings[self.model.nowMatching].user.shipper
            } else {
                self.model.nowMatchingUser.user = self.model.matchings[self.model.nowMatching].user.driver
            }
            self.model.nowMatchingInformation = self.model.matchings[self.model.nowMatching].matching
            
            
            Task{
                let staus = try await self.model.retriveMatchingUserStatus(userId: self.model.nowMatchingUser.user.userId)
                print(self.model.nowMatchingUser.user.userId)
                try await self.findStatusList(managerId: self.model.matchings[self.model.nowMatching].user.manager.userId, shipperId: self.model.matchings[self.model.nowMatching].user.shipper.userId)
                await MainActor.run {
                    self.model.nowMatchingUser.status = staus
                    self.isReView.toggle()
                }
            }
        }.store(in: &cancellables)
        
        changeLogoutCalled.sink { [weak self] () in
            
            guard let self = self else {
                return
            }
            
            guard let token = UserDefaults.standard.string(forKey: self.userDefaultKey) else {
                print("token is invalid")
                return
            }
                    
            Task {
                try? await APIRequests().deleteToken(token: token)
                await MainActor.run {
                    self.isReView.toggle()
                }
            }
            
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification")).sink { [weak self] notificatin in
            guard let self = self else { return }
            // マッチング登録の受信
            if notificatin.userInfo!["mode"] as! String == "matching" {
                Task {
                    try await self.setMatchings()
                    await MainActor.run {
                        self.isReView.toggle()
                    }
                }
            }
            // ステータスの受信
            if notificatin.userInfo!["mode"] as! String == "status" {
                let userId = notificatin.userInfo!["userId"] as! String
                Task {
                    let status = try await self.model.retriveMatchingUserStatus(userId: userId)
                    try await self.setMatchings()
                    await MainActor.run {
                        if userId == self.model.account.user.userId {
                            self.model.account.status = status
                        } else {
                            self.model.nowMatchingUser.status = status
                        }
                        self.isReView.toggle()
                    }
                }
            }
            
        }.store(in: &cancellables)
    }
    
    func login(userId: String, pass: String) async throws {
        let user = try await self.model.getUserInfo(id: userId, pass: pass)
        await MainActor.run {
            self.model.account.user = user
            loginCalled.send()
        }
    }
    
    func setUserStatus() async throws {
        let status = try await self.model.getUserStatus()
        await MainActor.run {
            self.model.account.status = status
        }
    }
    
    func setMatchings() async throws {
        var postData: [String: Any] = [:]
        switch model.account.user.role {
        case "運転手":
            postData = ["driver": model.account.user.userId,"manager":"","shipper":""]
            break
        case "荷主":
            postData = ["driver": "","manager": "","shipper": model.account.user.userId]
            break
        case "管理者":
            postData = ["driver": "","manager": model.account.user.userId,"shipper":""]
            break
        default:
            break
        }
        let matchings = try await self.model.retriveMatchngGroup(postData: postData)
        await MainActor.run {
            self.model.matchings = matchings
        }
    }
    
    /// ステータスリストの受信
    func findStatusList(managerId: String, shipperId: String) async throws {
        let defaultStatusList = try await self.model.retrieveDefaultStatus()
        let groupStatusList = try await self.model.retriveMatchingStatus(managerId: managerId, shipperId: shipperId)
        await MainActor.run {
            var statusList = defaultStatusList
            statusList.append(contentsOf: groupStatusList)
            self.model.statusList = statusList
        }
    }
    
    /// ステータスの送信
    func updateUserStatus(statusId: String) async throws -> UserStatus {
        let updateStatus = try await self.model.updateMyStatus(userId: self.model.account.user.userId, statusId: statusId)
        return updateStatus
    }
    
    // ログアウト処理
    func initModels(){
        self.model.account = MyUser()
        self.model.statusList = []
        self.model.matchings = []
        self.model.nowMatchingUser = MyUser()
        self.model.nowMatching = -1
    }
}
