//
//  ContentView.swift
//  iP
//
//  Created by Andy Hoo on 12/7/22.
//

import SwiftUI
import MapKit

struct IPView: View {
    @StateObject var ipv = IPViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $ipv.location)
                .ignoresSafeArea()
            Circle()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.blue.opacity(0.40))
            
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text("**IP**: \(ipv.ipAddress)")
                    Text("\(ipv.ipGeo.city), \(ipv.ipGeo.country)")
                }
                .padding()
                .frame(width: 330)
                .background(.thickMaterial)
                .cornerRadius(10)
                .padding(.vertical, 50)
            }
        }
    }
}
