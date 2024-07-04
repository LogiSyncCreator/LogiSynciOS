//
//  EnvModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/23.
//

import Foundation
import Combine


class EnvModel: ObservableObject {
    @Published var user: User = User(id: "", userId: "", pass: "", profile: "", name: "", company: "", role: "", phone: "", delete: false)
    @Published var matching: [Matching] = []
    @Published var statusData: Status = Status(id: "", userId: "", name: "", createAt: "", delete: false)
    @Published var nowStatus: CustomStatus = CustomStatus(id: "", name: "", color: "", icon: "", manager: "", shipper: "", delete: false, index: 0)
    @Published var statusList: [CustomStatus] = []
    @Published var nowMatching: Matching = Matching(id: "", manager: "", shipper: "", driver: "", address: "", start: "", delete: false)
    @Published var nowShipper: User = User(id: "", userId: "", pass: "", profile: "", name: "", company: "", role: "", phone: "", delete: false)
    @Published var nowShipperStatus: Status = Status(id: "", userId: "", name: "", createAt: "", delete: false)
    @Published var selectedMenberStatus: CustomStatus = CustomStatus(id: "", name: "", color: "", icon: "", manager: "", shipper: "", delete: false, index: 0)
    @Published var members: [User] = []
    @Published var matchSort: [Matching] = []
    @Published var nowMatchingLocations: [MatchingLocation] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellable = Set<AnyCancellable>()
    private let userDefaultsKey = "nowMatching"
    private let userDefaultsKey2 = "nowShipper"
    private let userDefaultsKey3 = "selectedMenberStatus"
    private let userDefaultsKey4: String = "token"
    
    init() {
        
//        loadMatchingFromUserDefaults()
//        loadShipperFromUserDefaults()
//        loadSelectedStatusFromUserDefaults()
            $user
                .dropFirst() // 初期値の変更を無視
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    
                    Task {
                        try? await self.sendToken()
                        try? await self.setMatching()
                        try? await self.setStatus()
                        try? await self.setCommonStatus()
                        try? await self.setGroupStatus()
                        try? await self.setNowStatus()
                        
                    }
                }
                .store(in: &cancellables)
        
        $statusData
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task{
                    try await APIManager().updateNowStatus(param: "\(self.user.userId)/\(self.statusData.name)")
                    await MainActor.run {
                        for status in self.statusList {
                            if status.name == self.statusData.name {
                                self.nowStatus = status
                            }
                        }
                    }
                }
            }.store(in: &cancellables)
        
        $matching
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    try? await self.setShippers()
                }
            }.store(in: &cancellables)
        
        $nowMatching
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    try? await self.setCommonStatus()
                    try? await self.setGroupStatus()
                    try? await self.setOnlineStatus()
                    
                    if self.user.role != "運転手" {
                        try? await self.setMatchingLocations()
                    }
                    
//                    self.saveMatchingToUserDefaults(self.nowMatching)
//                    self.saveShipperToUserDefaults(self.nowShipper)
                }
            }.store(in: &cancellables)
        $nowShipper
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    try? await self.setSelectedMenberStatus()
//                    self.saveSelectedStatusToUserDefaults(self.selectedMenberStatus)
                }
            }.store(in: &cancellables)
        
//        NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification"))
//            .sink { [weak self] notification in
//                guard let self = self else { return }
//                // 通知の監視
//                if notification.userInfo?["mode"] != nil {
//                    print("バックグラウンドから通知")
//                    if notification.userInfo!["mode"] as! String == "status" {
//                        Task {
//                            try? await self.setSelectedMenberStatus()
//                        }
//                    }
//                } else {
//                    print("不明な通知")
//                }
//            }.store(in: &cancellable)

        }

    func setUser(json: Data) {
            Task {
                do {
                    let decodedUser = try JSONDecoder().decode(User.self, from: json)
                    await MainActor.run {
                        self.user = decodedUser
                    }
                } catch {
                    print("Json decode error.")
                }
            }
        }
    
    
    func setNowStatus() async throws {
        for status in statusList {
            if status.name == self.statusData.name {
                let json = try await APIManager().updateNowStatus(param: "\(user.userId)/\(self.statusData.name)")
                
                let updatedStatusData = try JSONDecoder().decode(Status.self, from: json)
                
                await MainActor.run {
                    self.statusData = updatedStatusData
                }
            }
        }
    }
    
    func setOnlineStatus() async throws {
        let json = try await APIManager().updateNowStatus(param: "\(user.userId)/オンライン")
        
        let updatedStatusData = try JSONDecoder().decode(Status.self, from: json)
        
        await MainActor.run {
            self.statusData = updatedStatusData
        }
    }
    
    func setMatching() async throws {
            var json: Data? = nil
            
            switch user.role {
            case "運転手":
                json = try await APIManager().getMatching(driver: user.userId)
            case "荷主":
                json = try await APIManager().getMatching(shipper: user.userId)
            case "管理者":
                json = try await APIManager().getMatching(manager: user.userId)
            default:
                break
            }

            do {
                if let jsondata = json {
                    let decodedMatchings = try JSONDecoder().decode([Matching].self, from: jsondata)
                    await MainActor.run {
                        self.matching = decodedMatchings
                    }
                }
            } catch {
                print("Json decode error.")
            }
        }
    
    func setStatus() async throws {
        let json = try await APIManager().getNowStatus(param: user.userId)
        do {
            try await MainActor.run {
                self.statusData = try JSONDecoder().decode(Status.self, from: json)
                print(self.statusData.name)
            }
        } catch {
            print("Json decode error.")
        }
    }
    
    func setCommonStatus() async throws {
        await MainActor.run {
            self.statusList = []
        }
        let json = try await APIManager().commonStatus()
        do {
            try await MainActor.run {
                self.statusList = try JSONDecoder().decode([CustomStatus].self, from: json)
            }
        } catch {
            print("Json decode error.")
        }
    }
    
    func setGroupStatus() async throws {
        let json = try await APIManager().matchingStatus(param: "\(nowMatching.manager)/\(nowMatching.shipper)")
        do {
            try await MainActor.run {
                let msl = try JSONDecoder().decode([CustomStatus].self, from: json)
                self.statusList.append(contentsOf: msl)
            }
        }
    }
    
    func setSelectedMenberStatus() async throws {
        let json = try await APIManager().getSearchUserStatus(param: self.nowShipper.userId)
        
        try await MainActor.run {
            let data = try JSONDecoder().decode([CustomStatus].self, from: json)
            self.selectedMenberStatus = data.first!
            for status in data {
                for row in self.statusList {
                    if row.icon == status.icon && row.name == status.name {
                        self.selectedMenberStatus = status
                        return
                    }
                }
            }
        }
    }
    
    func setShippers() async throws {
        guard !matching.isEmpty else {
            print("Matching array is empty")
            return
        }

        for match in matching {
            
            do {
                var json = Data()
                if self.user.role == "運転手" {
                    json = try await APIManager().searchUser(param: match.shipper)
                } else {
                    json = try await APIManager().searchUser(param: match.driver)
                }
                let shipper = try JSONDecoder().decode(User.self, from: json)
                await MainActor.run {
                    self.matchSort.append(match)
                    self.members.append(shipper)
                }
            } catch {
                print("err")
            }
            
        }

        await MainActor.run {
            print("Total shippers: \(self.members.count)")
        }
    }
    
    func setMatchingLocations() async throws {
        let json = try await APIManager().searchLocation(param: self.nowMatching.driver)
        let locations = try JSONDecoder().decode([MatchingLocation].self, from: json)
        await MainActor.run {
            self.nowMatchingLocations = locations
        }
    }
    
//    // userdefaults
//    private func saveMatchingToUserDefaults(_ matching: Matching) {
//            do {
//                let data = try JSONEncoder().encode(matching)
//                UserDefaults.standard.set(data, forKey: userDefaultsKey)
//            } catch {
//                print("Failed to save matching to UserDefaults: \(error)")
//            }
//        }
//        
//        private func loadMatchingFromUserDefaults() {
//            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
//            do {
//                let matching = try JSONDecoder().decode(Matching.self, from: data)
//                nowMatching = matching
//            } catch {
//                print("Failed to load matching from UserDefaults: \(error)")
//            }
//        }
//    // userdefaults
//    private func saveShipperToUserDefaults(_ shipper: User) {
//            do {
//                let data = try JSONEncoder().encode(shipper)
//                UserDefaults.standard.set(data, forKey: userDefaultsKey2)
//            } catch {
//                print("Failed to save matching to UserDefaults: \(error)")
//            }
//        }
//        
//        private func loadShipperFromUserDefaults() {
//            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey2) else { return }
//            do {
//                let shipper = try JSONDecoder().decode(User.self, from: data)
//                nowShipper = shipper
//            } catch {
//                print("Failed to load matching from UserDefaults: \(error)")
//            }
//        }
    // userdefaults
//    private func saveSelectedStatusToUserDefaults(_ status: CustomStatus) {
//            do {
//                let data = try JSONEncoder().encode(status)
//                UserDefaults.standard.set(data, forKey: userDefaultsKey3)
//            } catch {
//                print("Failed to save matching to UserDefaults: \(error)")
//            }
//        }
//        
//        private func loadSelectedStatusFromUserDefaults() {
//            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey3) else { return }
//            do {
//                let status = try JSONDecoder().decode(CustomStatus.self, from: data)
//                selectedMenberStatus = status
//            } catch {
//                print("Failed to load matching from UserDefaults: \(error)")
//            }
//        }
//    
//    func deleteUserDefaults(){
//        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
//        UserDefaults.standard.removeObject(forKey: userDefaultsKey2)
//        UserDefaults.standard.removeObject(forKey: userDefaultsKey3)
//    }
    
    func sendToken() async throws {
        let token = UserDefaults.standard.string(forKey: userDefaultsKey4)
        if let token = token {
            let status = try await APIManager().sendRequest(postData: ["userId" : self.user.userId, "token": token], endPoint: "/push")
            print(status)
        }
    }
}

struct User: Identifiable, Codable {
    var id: String
    var userId: String
    var pass: String? = ""
    var profile: String
    var name: String
    var company: String
    var role: String
    var phone: String
    var delete: Bool? = false
}

struct Matching: Identifiable, Codable, Hashable {
    var id: String
    var manager: String
    var shipper: String
    var driver: String
    var address: String
    var start: String
    var delete: Bool
}

struct ResponseNowStatusDTO: Identifiable, Codable {
    var id: UUID
    var userId: String
    var statusId: String
    var name: String
    var color: String
    var icon: String
    var delete: Bool
}

struct CustomStatus: Identifiable, Codable {
    var id: String
    var name: String
    var color: String
    var icon: String
    var manager: String
    var shipper: String
    var delete: Bool
    var index: Int
}



struct Status: Codable {
    var id: String = ""
    var userId: String = ""
    var name: String = ""
    var createAt: String = ""
    var delete: Bool = false
}
