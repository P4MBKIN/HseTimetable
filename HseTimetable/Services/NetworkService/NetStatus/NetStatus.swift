//
//  NetStatus.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Network
import Foundation

@available(iOS 12.0, *)
public class NetStatus {
    
    public static let shared = NetStatus()
    
    public var monitor: NWPathMonitor?
    
    public var isMonitoring = false
    
    public var didStartMonitoringHandler: (() -> Void)?
    public var didStopMonitoringHandler: (() -> Void)?
    public var netStatusChangeHandler: (() -> Void)?
    
    public var isConnected: Bool {
        guard let monitor = self.monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    public var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = self.monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = self.monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    public var isExpensive: Bool {
        return self.monitor?.currentPath.isExpensive ?? false
    }
    
    // MARK:- Init & Deinit
    private init() {
        
    }
    
    deinit {
        stopMonitoring()
    }
    
    // MARK:- Method Implementation
    public func startMonitoring() {
        guard !self.isMonitoring else { return }
        
        self.monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        self.monitor?.start(queue: queue)
        
        self.monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        
        self.isMonitoring = true
        self.didStartMonitoringHandler?()
    }
    
    
    public func stopMonitoring() {
        guard self.isMonitoring, let monitor = self.monitor else { return }
        monitor.cancel()
        self.monitor = nil
        self.isMonitoring = false
        self.didStopMonitoringHandler?()
    }
}
