//
//  CountryManager.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 30/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import Foundation
import CoreLocation

class CountryManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var onCountryReceived: ((String?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            checkAuthorizationStatus()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            fetchCountry()
        case .denied, .restricted:
            onCountryReceived?("Location permission denied")
        default:
            break
        }
    }
    

    
    func fetchCountry() {
        guard CLLocationManager.locationServicesEnabled() else {
            onCountryReceived?("Location services are disabled")
            return
        }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.onCountryReceived?("Geocoding error: \(error.localizedDescription)")
                return
            }
            let country = placemarks?.first?.country
            self?.onCountryReceived?(country ?? "Unknown Country")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onCountryReceived?("turn Settings-Location: ON")
    }
}


