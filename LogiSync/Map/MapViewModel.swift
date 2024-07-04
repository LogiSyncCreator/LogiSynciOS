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
    
    private var cancellables = Set<AnyCancellable>()
    public var sendLocationEvent = PassthroughSubject<SendLocation, Never>()
    
    init(){
        sendLocationEvent.sink {[weak self] data in
            
            guard let self = self else { return }
            
            Task{
                try? await self.sendMyLocation(sendLocation: data)
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
        try await APIRequests().setNowMyLocation(postData: postData)
    }
    
}

struct SendLocation {
    var user: MyUser
    var location: CLLocationCoordinate2D
    var message: String
}
