//
//  MapViewModel.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/07/02.
//

import Foundation
import MapKit
import Combine

class MapViewModel: ObservableObject {
    // SwiftDataの内容を送信して
    //    送信済みのものに対してsendingをtrueにする
    //    位置情報を削除する
    
    @Published var isReview: Bool = false
    @Published var model = MapModel()
    
    private var cancellables = Set<AnyCancellable>()
    public var sendLocationEvent = PassthroughSubject<SendLocation, Never>()
    public var receivedLocationEvent = PassthroughSubject<String, Never>()
    
    init(){
        sendLocationEvent.sink {[weak self] data in
            
            guard let self = self else { return }
            
            Task{
                try? await self.sendMyLocation(sendLocation: data)
                await MainActor.run {
                    self.receivedLocationEvent.send(data.user.user.userId)
                    self.isReview.toggle()
                }
            }
            
        }.store(in: &cancellables)
        
        receivedLocationEvent.sink {[weak self] userId in
            guard let self = self else { return }
            
            Task {
                try? await self.setUserLocation(user: userId)
                await MainActor.run {
                    print(self.model.userLocations.count)
                    self.isReview.toggle()
                }
            }
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification")).sink { [weak self] notificatin in
            guard let self = self else { return }
            
            // ステータスの受信
            if notificatin.userInfo!["mode"] as! String == "location" {
                if let userId = notificatin.userInfo?["userId"] as? String {
                    Task {
                        try? await self.setUserLocation(user: userId)
                    }
                }
            }
            
        }.store(in: &cancellables)
    }
    
    func sendMyLocation(sendLocation: SendLocation) async throws {
        let postData: [String: Any] = [
            "userId": sendLocation.user.user.userId,
            "longitude": sendLocation.location.longitude,
            "latitude": sendLocation.location.latitude,
            "status": sendLocation.message,
            "delete": false
        ]
        try await APIRequests().setNowMyLocation(postData: postData, matchingId: sendLocation.matching.id)
    }
    
    func setUserLocation(user: String) async throws {
        let locationList = try await self.model.retriveUserLocation(user: user)
        await MainActor.run {
            self.model.userLocations = locationList
        }
    }
    
    func deleteLocations(uuid: String) async throws {
        try await self.model.deleteUserLocation(uuid: uuid)
    }
    
}

struct SendLocation {
    var user: MyUser
    var location: CLLocationCoordinate2D
    var message: String
    var matching: MatchingInformation
}
