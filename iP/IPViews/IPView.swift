//
//  ContentView.swift
//  iP
//
//  Created by Andy Hoo on 12/7/22.
//

import SwiftUI
import MapKit
import Network

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
                            Text("Second View")){
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

// Onboarding
struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView {
            PageView(
                title: "Welcome to iP!",
                subtitle: "We're glad to have you here.",
                imageName: "Intro",
                showsDismissButton: false,
                shouldShowOnboarding: $shouldShowOnboarding
            )
            
            PageView(
                title: "Locating...",
                subtitle: "We can find and map your IP Address in no time!",
                imageName: "Location",
                showsDismissButton: false,
                shouldShowOnboarding: $shouldShowOnboarding
            )
            
            PageView(
                title: "Basic Network Info",
                subtitle: "We also can give you your device's current basic network info!",
                imageName: "Info",
                showsDismissButton: true,
                shouldShowOnboarding: $shouldShowOnboarding
            )
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct PageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()
            
            Text(title)
                .font(.system(size: 32))
                .padding()
            
            Text(subtitle)
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.secondaryLabel))
                .padding()
            
            if showsDismissButton {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.black)
                        .cornerRadius(3.0)
                })
            }
        }
    }
}

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var active = false
    @Published var expensive = false
    @Published var constrained = false
    @Published var connectionType = NWInterface.InterfaceType.other
    
    init() {
        monitor.pathUpdateHandler = {path in
            DispatchQueue.main.async {
                self.active = path.status == .satisfied
                self.expensive = path.isExpensive
                self.constrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        monitor.start(queue: queue)
    }
    
}

struct IP_Previews: PreviewProvider {
    static var previews: some View{
        IPView()
    }
}
