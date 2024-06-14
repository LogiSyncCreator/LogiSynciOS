//
//  LocationManeager.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager:NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    var region: CLCircularRegion?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
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
    
}
