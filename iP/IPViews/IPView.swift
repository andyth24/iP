//
//  ContentView.swift
//  iP
//
//  Created by Andy Hoo on 12/7/22.
//

import SwiftUI
import MapKit

struct IPView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var ipv = IPViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $ipv.location)
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.blue.opacity(0.40))
                
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("\("IP Address"): \(ipv.ipAddress)")
                        Text("\("Location"): \(ipv.ipGeo.city), \(ipv.ipGeo.country)")
                        NavigationLink(destination:
                                        NetworkView()){
                            Image(systemName: "info.circle.fill")
                            Text("Click Here for Network Info")
                        }
                    }
                    .padding()
                    .frame(width: 350)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding(.vertical, 35)
                }
            }
        }
        
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: { OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

struct IP_Previews: PreviewProvider {
    static var previews: some View{
        IPView()
    }
}
