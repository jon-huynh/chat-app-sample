//
//  NetworkMonitor.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var isConnected: Bool = true

    private init() {}

    func startMonitoring(statusChangeHandler: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            let status = path.status == .satisfied
            if self.isConnected != status {
                self.isConnected = status
                statusChangeHandler(status)
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
