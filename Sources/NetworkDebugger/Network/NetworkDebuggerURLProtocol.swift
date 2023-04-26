//
//  NetworkDebuggerURLProtocol.swift
//  
//
//  Created by Michael Artes on 27.02.23.
//  Copyright © 2023 Schwarz IT KG.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class NetworkDebuggerURLProtocol: URLProtocol {
    
    // MARK: Init
    
    private static func shouldInit(with request: URLRequest) -> Bool {
        guard NetworkDebugger.started,
              URLProtocol.property(forKey: Constants.flag, in: request) == nil
        else { return false }
        
        guard let url = request.url,
              let scheme = url.scheme,
              scheme.starts(with: "http")
        else { return false }
        
        guard !NetworkDebugger.ignoredHosts.contains(url.ndHost),
              url.ndHost != "N/A"
        else { return false }
        
        return true
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        shouldInit(with: request)
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        if task is URLSessionWebSocketTask {
            return false
        }
        guard let currentRequest = task.currentRequest else { return false }
        return shouldInit(with: currentRequest)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let mutableUrlRequest = request as? NSMutableURLRequest else { return request }
        URLProtocol.setProperty(true, forKey: Constants.flag, in: mutableUrlRequest)
        return mutableUrlRequest as URLRequest
    }
    
    // MARK: Request handling
    
    private lazy var urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    var networkDebuggerModel: NetworkDebuggerModel?
    
    override func startLoading() {
        let networkDebuggerModel = NetworkDebuggerModel(for: request)
        self.networkDebuggerModel = networkDebuggerModel
        DispatchQueue.main.async {
            ModelsService.shared.append(model: networkDebuggerModel)
            
            let host = networkDebuggerModel.url.ndHost
            if let amountOfRequests = StatisticsService.shared.hostsAmountOfRequests[host] {
                StatisticsService.shared.hostsAmountOfRequests[host] = amountOfRequests + 1
            } else {
                StatisticsService.shared.hostsAmountOfRequests[host] = 1
            }
            
            if StatisticsService.shared.hostsPathsAmountOfRequests[host] == nil {
                StatisticsService.shared.hostsPathsAmountOfRequests[host] = [:]
            }
            let path = networkDebuggerModel.url.ndPath
            if let amountOfRequests = StatisticsService.shared.hostsPathsAmountOfRequests[host]![path] {
                StatisticsService.shared.hostsPathsAmountOfRequests[host]![path] = amountOfRequests + 1
            } else {
                StatisticsService.shared.hostsPathsAmountOfRequests[host]![path] = 1
            }
        }
        
        let dataTask = urlSession.dataTask(with: request)
        dataTask.resume()
    }
    
    override func stopLoading() {
        urlSession.getAllTasks {
            $0.forEach { $0.cancel() }
        }
        urlSession.invalidateAndCancel()
    }
}
