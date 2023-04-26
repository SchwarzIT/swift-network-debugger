//
//  NetworkDebuggerURLProtocol+URLSession.swift
//  
//
//  Created by Michael Artes on 01.03.23.
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

extension NetworkDebuggerURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        DispatchQueue.main.async {
            self.networkDebuggerModel?.initResponse(body: data)
            
            guard let model = self.networkDebuggerModel else { return }
            let host = model.url.ndHost
            if let amountOfBytes = StatisticsService.shared.hostsAmountOfBytes[host] {
                StatisticsService.shared.hostsAmountOfBytes[host] = amountOfBytes + Double(data.count)
            } else {
                StatisticsService.shared.hostsAmountOfBytes[host] = Double(data.count)
            }
            
            if StatisticsService.shared.hostsPathsAmountOfBytes[host] == nil {
                StatisticsService.shared.hostsPathsAmountOfBytes[host] = [:]
            }
            let path = model.url.ndPath
            if let amountOfBytes = StatisticsService.shared.hostsPathsAmountOfBytes[host]![path] {
                StatisticsService.shared.hostsPathsAmountOfBytes[host]![path] = amountOfBytes + Double(data.count)
            } else {
                StatisticsService.shared.hostsPathsAmountOfBytes[host]![path] = Double(data.count)
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let policy = URLCache.StoragePolicy(rawValue: request.cachePolicy.rawValue) ?? .notAllowed
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
        completionHandler(.allow)
        
        if let httpResponse = response as? HTTPURLResponse {
            DispatchQueue.main.async {
                guard let networkDebuggerModel = self.networkDebuggerModel else { return }
                let now = Date()
                networkDebuggerModel.initResponse(httpResponse, at: now)
                
                let time = Double(now.timeIntervalSince(networkDebuggerModel.requestModel.date))
                let host = networkDebuggerModel.url.ndHost
                if let amountOfTime = StatisticsService.shared.hostsAmountOfTime[host] {
                    StatisticsService.shared.hostsAmountOfTime[host] = amountOfTime + time
                } else {
                    StatisticsService.shared.hostsAmountOfTime[host] = time
                }
                
                if StatisticsService.shared.hostsPathsAmountOfTime[host] == nil {
                    StatisticsService.shared.hostsPathsAmountOfTime[host] = [:]
                }
                let path = networkDebuggerModel.url.ndPath
                if let amountOfTime = StatisticsService.shared.hostsPathsAmountOfTime[host]![path] {
                    StatisticsService.shared.hostsPathsAmountOfTime[host]![path] = amountOfTime + time
                } else {
                    StatisticsService.shared.hostsPathsAmountOfTime[host]![path] = time
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
            DispatchQueue.main.async {
                self.networkDebuggerModel?.initError(with: error)
            }
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        completionHandler(request)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else { return }
        DispatchQueue.main.async {
            self.networkDebuggerModel?.initError(with: error)
        }
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let wrappedChallenge = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: NetworkDebuggerAuthenticationChallengeSender(handler: completionHandler))
        client?.urlProtocol(self, didReceive: wrappedChallenge)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        client?.urlProtocolDidFinishLoading(self)
    }
}
