//
//  IPViewModel.swift
//  iP
//
//  Created by Andy Hoo on 12/7/22.
//

import Foundation
import SwiftUI
import MapKit

extension IPView {
    final class IPViewModel: ObservableObject {
        @Published var ipAddress: String = "Retrieving..."
        @Published var ipGeo = IPGeo(city: "City", country: "Country", timezone: "Timezone")
        @Published var location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        private let api = ManageAPIs()
    
        init() {
            callIP()
        }
        
        // Helper function to make sure items get updated on the main thread
        func runMain(_ method:@escaping () -> Void) {
            DispatchQueue.main.async {
                withAnimation {
                    method()
                }
            }
        }
        
        private func callIP() {
            api.callData(url: "https://api.ipify.org?format=json", model: IP.self) { result in
                self.runMain {
                    self.ipAddress = result.ip
                    self.callGeoData(ip: result.ip)
                    self.callLocation(ip: result.ip)
                }
            } failure: { error in
                self.runMain {
                    print("IP: \(error.localizedDescription)")
                    
                    // In case of error, try again after 10 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        print("Attempting to call for IP again...")
                        self.callIP()
                    }
                }
            }
        }
        
        private func callGeoData(ip: String) {
            api.callData(url: "https://ipinfo.io/\(ip)/geo", model: IPGeo.self) { result in
                self.runMain {
                    self.ipGeo = result
                }
            } failure: { error in
                print("GeoData: \(error.localizedDescription)")
            }
        }

        private func callLocation(ip: String) {
            api.callData(url: "https://ipapi.co/\(ip)/json/", model: IPCoordinates.self) { result in
                self.runMain {
                    self.location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                }
            } failure: { error in
                print("IPCoordinates: \(error.localizedDescription)")
            }
        }
    }
}

