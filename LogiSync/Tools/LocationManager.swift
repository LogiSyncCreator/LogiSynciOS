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
    private let updates = CLLocationUpdate.liveUpdates()
    
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        TestLocalNotification().scheduleNotification()
        }
    
    func liveUpdates() async throws {
        let location = CLLocationCoordinate2D(latitude: 35.1495518 , longitude: 136.8542867)
        self.startMonitoringRegion(at: location, radius: 30, identifier: UUID().uuidString)
        for try await update in updates {
            guard let update = update.location else { return }
            print(update.coordinate.latitude)
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
    
    // 中間距離
    func distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
}
