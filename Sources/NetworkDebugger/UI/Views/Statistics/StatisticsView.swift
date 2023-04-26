//
//  StatisticsView.swift
//  
//
//  Created by Michael Artes on 16.03.23.
//

import Charts
import SwiftUI

@available(iOS 16.0, *)
struct StatisticsView: View {
    @EnvironmentObject var modelsService: ModelsService
    @EnvironmentObject var statisticsService: StatisticsService
    
    var body: some View {
        List {
            Section {
                amountOfRequests
            } header: {
                Text("Amount of requests")
            } footer: {
                Text("This data is highly variable. The more you use the app the more requests will collect.")
            }
            
            Section {
                amountOfBytes
            } header: {
                Text("Amount of data")
            } footer: {
                Text("The amount of data depends on the amount of requests made and on the type of data being loaded. Images typically use a lot more data than information.")
            }
            
            Section {
                amountOfTime
            } header: {
                Text("Amount of time")
            } footer: {
                Text("The average time for a response usually depends on the size of the data and the work happening in the backend.")
            }
            
            Section {
                amountOfErrors
            } header: {
                Text("Amount of errors")
            }
        }
        .navigationTitle("Statistics")
        .ensureNavigationBarVisible()
    }
    
    private var amountOfRequests: some View {
        ChartView(limitedHeight: true, elements: statisticsService.hostsAmountOfRequests) { host in
            if let amountOfRequests = statisticsService.hostsAmountOfRequests[host] {
                let percentage = (amountOfRequests / statisticsService.totalAmountOfRequests) * 100
                Text("\(Int(amountOfRequests)) (\(Int(percentage))%)").font(.caption)
            }
        } subviewForKey: {
            if let hostPathsAmountOfRequests = statisticsService.hostsPathsAmountOfRequests[statisticsService.selectedHost] {
                ChartView(limitedHeight: false, elements: hostPathsAmountOfRequests) { path in
                    if let amountOfRequests = hostPathsAmountOfRequests[path] {
                        let percentage = (amountOfRequests / statisticsService.totalAmountOfRequests(for: statisticsService.selectedHost)) * 100
                        Text("\(Int(amountOfRequests)) (\(Int(percentage))%)").font(.caption)
                    }
                }
            }
        }
    }
    
    private var amountOfBytes: some View {
        ChartView(limitedHeight: true, elements: statisticsService.hostsAmountOfBytes) { host in
            if let amountOfBytes = statisticsService.hostsAmountOfBytes[host] {
                let percentage = (amountOfBytes / statisticsService.totalAmountOfBytes) * 100
                Text("\(ByteCountFormatter().string(fromByteCount: Int64(amountOfBytes))) (\(Int(percentage))%)")
            }
        } subviewForKey: {
            if let hostPathsAmountOfBytes = statisticsService.hostsPathsAmountOfBytes[statisticsService.selectedHost] {
                ChartView(limitedHeight: false, elements: hostPathsAmountOfBytes) { path in
                    if let amountOfBytes = hostPathsAmountOfBytes[path] {
                        let percentage = (amountOfBytes / statisticsService.totalAmountOfBytes(for: statisticsService.selectedHost)) * 100
                        Text("\(ByteCountFormatter().string(fromByteCount: Int64(amountOfBytes))) (\(Int(percentage))%)")
                    }
                }
            }
        }
    }
    
    private var amountOfTime: some View {
        ChartView(limitedHeight: true, elements: statisticsService.hostsAmountOfTime) { host in
            if let amountOfTime = statisticsService.hostsAmountOfTime[host], let amountOfRequests = statisticsService.hostsAmountOfRequests[host] {
                let percentage = (amountOfTime / statisticsService.totalAmountOfTime) * 100
                Text("\(String(format: "%.0f", (amountOfTime / amountOfRequests) * 1000))ms (\(Int(percentage))%)")
            }
        } subviewForKey: {
            if
                let hostPathsAmountOfTime = statisticsService.hostsPathsAmountOfTime[statisticsService.selectedHost],
                let hostPathsAmountOfRequests = statisticsService.hostsPathsAmountOfRequests[statisticsService.selectedHost]
            {
                ChartView(limitedHeight: false, elements: hostPathsAmountOfTime) { path in
                    if let amountOfTime = hostPathsAmountOfTime[path], let amountOfRequests = hostPathsAmountOfRequests[path] {
                        let percentage = (amountOfTime / statisticsService.totalAmountOfTime(for: statisticsService.selectedHost)) * 100
                        Text("\(String(format: "%.0f", (amountOfTime / amountOfRequests) * 1000))ms (\(Int(percentage))%)")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var amountOfErrors: some View {
        if statisticsService.totalAmountOfErrors <= 0 {
            Text("There are no errors (yet), good job!")
        } else {
            ChartView(limitedHeight: true, elements: statisticsService.hostsAmountOfErrors) { host in
                if let amountOfErrors = statisticsService.hostsAmountOfErrors[host] {
                    let percentage = (amountOfErrors / statisticsService.totalAmountOfErrors) * 100
                    Text("\(Int(amountOfErrors)) (\(Int(percentage)))%")
                }
            }
        }
    }
}
