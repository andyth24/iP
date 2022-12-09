//
//  NetworkView.swift
//  iP
//
//  Created by Andy Hoo on 12/9/22.
//

import Foundation
import SwiftUI

struct NetworkView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 30) {
                if(networkMonitor.active == true) {
                    Text("Connected: Yes")
                } else {
                    Text("Connected: No")
                }
                
                if(networkMonitor.constrained == true) {
                    Text("Low Data Mode: On")
                } else {
                    Text("Low Data Mode: Off")
                }
                
                if(networkMonitor.expensive == true) {
                    Text("Mobile Data/Hotspot: On")
                } else {
                    Text("Mobile Data/Hotspot: Off")
                }
                
                Text(verbatim: "Type: \(networkMonitor.connectionType)")
            }
        }
        .font(.title2)
        .navigationBarTitle("Your Device's Network Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
