//
//  StatisticsService.swift
//  
//
//  Created by Michael Artes on 16.03.23.
//

import Foundation

final class StatisticsService: ObservableObject {
    
    static let shared = StatisticsService()
    
    private init() { }
    
    var totalAmountOfBytes: Double {
        hostsAmountOfBytes.reduce(0) { $0 + $1.value }
    }
    var totalAmountOfRequests: Double {
        hostsAmountOfRequests.reduce(0) { $0 + $1.value }
    }
    var totalAmountOfTime: Double {
        hostsAmountOfTime.reduce(0) { $0 + $1.value }
    }
    var totalAmountOfErrors: Double {
        hostsAmountOfErrors.reduce(0) { $0 + $1.value }
    }
    
    func totalAmountOfBytes(for host: String) -> Double {
        guard let pathsBytes = hostsPathsAmountOfBytes[host] else { return 0 }
        return pathsBytes.reduce(0) { $0 + $1.value }
    }
    func totalAmountOfRequests(for host: String) -> Double {
        guard let pathsRequests = hostsPathsAmountOfRequests[host] else { return 0 }
        return pathsRequests.reduce(0) { $0 + $1.value }
    }
    func totalAmountOfTime(for host: String) -> Double {
        guard let pathsTimes = hostsPathsAmountOfTime[host] else { return 0 }
        return pathsTimes.reduce(0) { $0 + $1.value }
    }
    
    @Published var hostsAmountOfBytes = [String: Double]()
    @Published var hostsAmountOfRequests = [String: Double]()
    @Published var hostsAmountOfErrors = [String: Double]()
    @Published var hostsAmountOfTime = [String: Double]()
    
    @Published var hostsPathsAmountOfBytes = [String: [String: Double]]()
    @Published var hostsPathsAmountOfRequests = [String: [String: Double]]()
    @Published var hostsPathsAmountOfErrors = [String: [String: Double]]()
    @Published var hostsPathsAmountOfTime = [String: [String: Double]]()
    
    @Published var selectedHost = ""
}
