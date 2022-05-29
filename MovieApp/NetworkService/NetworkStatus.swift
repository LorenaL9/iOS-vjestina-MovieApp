//
//  NetworkStatus.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/26/22.
//

import Foundation
import Network

class NetworkStatus {
    private var checkNetwork: Bool = false
    private var monitor: NWPathMonitor!
    
    init(){
        monitor = NWPathMonitor()
    }
    
    func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.checkNetwork = true
            } else {
                print("No connection.")
                self.checkNetwork = false
            }

            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    func getNetworkStatus() -> Bool {
        return checkNetwork
    }
}
