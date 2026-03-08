//
//  NetworkMonitor.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/8/26.
//

import Foundation
import Network
import Combine

// NetworkMonitor.swift: dealing with offline case where we don't display patterns

class NetworkMonitor: ObservableObject {
    // NetworkMonitor: monitors whether the device currently has an internet connection
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")

    // publish connectivity so SwiftUI updates when it changes
    @Published var isConnected: Bool = true
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
