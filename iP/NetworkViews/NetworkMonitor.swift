//
//  NetworkMonitor.swift
//  iP
//
//  Created by Andy Hoo on 12/9/22.
//

import Foundation
import SwiftUI
import Network

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
