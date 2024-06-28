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
    
    init() {

        loginCalled.sink { [weak self] () in
            guard let self = self else { return }
            Task{
                try await self.getUserStatus()
                try await self.getMatchings()
                try await self.findStatusList(managerId: "manager", shipperId: "shipper")
                await MainActor.run {
                    self.isReView.toggle()
                }
            }
        }.store(in: &cancellables)
        
        changeStatusCalled.sink { [weak self] customStatus in
            guard let self = self else { return }
            Task{
                let status = try await self.updateUserStatus(statusId:customStatus.id)
                
                let nowStatus = UserStatus(id: status.id, userId: status.userId, statusId: status.statusId, name: customStatus.name, color: customStatus.color, icon: customStatus.icon)
                
                await MainActor.run {
                   self.model.account.status = nowStatus
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
            
            
            Task{
                
                let staus = try await self.model.retriveMatchingUserStatus(userId: self.model.nowMatchingUser.user.userId)
                print(self.model.nowMatchingUser.user.userId)
                await MainActor.run {
                    self.model.nowMatchingUser.status = staus
                    self.isReView.toggle()
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
    
    func getUserStatus() async throws {
        let status = try await self.model.getUserStatus()
        await MainActor.run {
            self.model.account.status = status
        }
    }
    
    func getMatchings() async throws {
        var postData: [String: Any] = [:]
        switch model.account.user.role {
        case "運転手":
            postData = ["driver": model.account.user.userId,"manager":"","shipper":""]
            break
        case "荷主":
            postData = ["driver": "","manager": model.account.user.userId,"shipper":""]
            break
        case "管理者":
            postData = ["driver": "","manager": "","shipper": model.account.user.userId]
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
    
}
