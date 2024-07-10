//
//  LocationManeager.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class LocationManager:NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let updates = CLLocationUpdate.liveUpdates()
    
    @Published var location: CLLocation? = nil
    @Published var updateLocationFlag: Bool = false
    @Published var updateLocationstart: Bool = false
    @Published var targetLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var targetMatching: MatchingInformation = MatchingInformation()
    @Published var targetUser: MyUser = MyUser()
    @Published var myUser: MyUser = MyUser()
    
    @Published var intervalTime: Int = 10
    @Published var rudius: CLLocationDistance = 1000 // m単位
    
    let userDefaultKeyIntevalTime: String = "interval"
    let userDefaultKeyrudius: String = "rudius"
    
    var region: CLCircularRegion?
    
    private var cancellables = Set<AnyCancellable>()
    public let sendMessages = PassthroughSubject<String, Never>()
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        if loadUserdefaultIntervalTime() != 0 && loadUserdefaultIntervalTime() != self.intervalTime {
            self.intervalTime = loadUserdefaultIntervalTime()
        }
        if loadUserdefaultrudius() != 0 && loadUserdefaultrudius() != self.rudius {
            self.rudius = loadUserdefaultrudius()
        }
        
        sendMessages.sink { [weak self] message in
            guard let self = self else { return }
            Task{
                try await APIRequests().sendUserMessage(user: self.targetUser.user.userId, message: message)
            }
        }.store(in: &cancellables)
        
    }
    
    func startMonitoringRegion(at location: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.region = CLCircularRegion(center: location, radius: radius, identifier: identifier)
        self.region?.notifyOnEntry = true // 領域に入ったときに通知
        self.region?.notifyOnExit = false // 領域から出たときは通知しない
        
        if let region = self.region {
            self.locationManager.startMonitoring(for: region)
        }
        
    }
    
    func stopMonitoringRegion() {
        if let region = self.region {
            self.locationManager.stopMonitoring(for: region)
        }
    }
    
    func requestLocationPermission() {
        // 位置情報サービスの利用が許可されていない場合
        if locationManager.authorizationStatus == .denied {
            // 許可を求めるダイアログを表示
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.sendMessages.send("\(Int(rudius))m圏内です")
    }
    
    func liveUpdates(_ rudius: CLLocationDistance = 1000,user: MyUser, sendLocationEvent: PassthroughSubject<SendLocation, Never>, receivedLocationEvent: PassthroughSubject<String, Never>) async throws {
        print("Start liveUpdate")
        
        // 任意範囲警告
        let arbitraryRadiusIdentifier = UUID().uuidString
        self.startMonitoringRegion(at: self.targetLocation, radius: rudius, identifier: arbitraryRadiusIdentifier)

        await withTaskGroup(of: Void.self) {[weak self] group in
            guard let self = self else { return }
            // 5分おきにイベントを発生させるタスク
            group.addTask {
                await self.periodicEventTask(user: user, sendLocationEvent: sendLocationEvent, receivedLocationEvent: receivedLocationEvent)
            }

            // 位置情報の更新処理を行うタスク
            group.addTask {
                await self.locationUpdateTask(rudius: self.rudius ,sendLocationEvent: sendLocationEvent, receivedLocationEvent: receivedLocationEvent)
            }
        }
    }
    
    private func periodicEventTask(user: MyUser, sendLocationEvent: PassthroughSubject<SendLocation, Never>, receivedLocationEvent: PassthroughSubject<String, Never>) async {
        while true {
            // 5分（300秒）待つ
            try? await Task.sleep(nanoseconds: UInt64(self.intervalTime) * 60 * 1_000_000_000)
            
            // 5分おきのイベント処理
            sendLocationEvent.send(SendLocation(user: user, location: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), message: "定時連絡", matching: self.targetMatching))
            receivedLocationEvent.send(user.user.userId)
            
            if self.updateLocationFlag {
                print("End liveUpdateLoop")
                return
            }
        }
    }
    
    private func locationUpdateTask(rudius: CLLocationDistance = 1000, sendLocationEvent: PassthroughSubject<SendLocation, Never>, receivedLocationEvent: PassthroughSubject<String, Never>) async {
        
        do {
            
            for try await update in self.updates {
                guard let update = update.location else { return }
                print(update.coordinate.latitude)
                
                let distanceMeters = distanceBetweenCoordinates(coordinate1: targetLocation, coordinate2: update.coordinate)
                
                if distanceMeters < rudius {
//                  distanceMetersがrudius圏内かつその数値が1km以上
                    TestLocalNotification().scheduleNotification("\(rudius)圏内に入りました")
                    Task { @MainActor in
                        try? await APIRequests().sendUserMessage(user: self.targetMatching.shipper, message: "\(rudius)圏内に入りました")
                        sendLocationEvent.send(SendLocation(user: self.myUser, location: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), message: "\(rudius)圏内に入りました", matching: self.targetMatching))
                        receivedLocationEvent.send(self.targetMatching.driver)
                    }
                }
                
                if distanceMeters < rudius && distanceMeters < 100 {
                    TestLocalNotification().scheduleNotification("近くにいます")
                    Task { @MainActor in
                        try? await APIRequests().sendUserMessage(user: self.targetMatching.shipper, message: "近くにいます")
                        sendLocationEvent.send(SendLocation(user: self.myUser, location: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), message: "近くにいます", matching: self.targetMatching))
                        receivedLocationEvent.send(self.targetMatching.driver)
                        return
                    }
                }
            }
        } catch {
            print("位置情報更新エラー: \(error.localizedDescription)")
        }
    }
    
    func geoCoding(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let placemark = placemarks?.first, let location = placemark.location else {
                completion(nil, NSError(domain: "GeocodingErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found"]))
                return
            }

            let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            completion(position, nil)
        }
    }
    
    // 中間座標
    func midpointCoordinate(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (coordinate1.latitude + coordinate2.latitude) / 2
        let longitude = (coordinate1.longitude + coordinate2.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // 距離
    func distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
    
    
    
    // ユーザーデフォルト
    // インターバルのセーブ
    func saveUserDefaultIntervalTime(time: Int){
        UserDefaults.standard.setValue(time, forKey: userDefaultKeyIntevalTime)
    }
    // インターバルのロード
    func loadUserdefaultIntervalTime() -> Int {
        let time = UserDefaults.standard.integer(forKey: userDefaultKeyIntevalTime)
        return time
    }
    // 範囲のセーブ
    func saveUserDefaultrudius(rudius: Double){
        UserDefaults.standard.setValue(rudius, forKey: userDefaultKeyrudius)
    }
    // 範囲のロード
    func loadUserdefaultrudius() -> Double {
        let rudius = UserDefaults.standard.double(forKey: userDefaultKeyrudius)
        return rudius
    }
}
