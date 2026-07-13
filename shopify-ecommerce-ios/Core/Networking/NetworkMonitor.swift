//
//  NetworkConnection.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation
import Network

@Observable
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = true
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
