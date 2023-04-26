//
//  RequestModel.swift
//  
//
//  Created by Michael Artes on 28.02.23.
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

final class RequestModel {
    let httpMethod: String
    let cachePolicy: String
    let storagePolicy: String?
    let timeout: Double
    let httpHeaders: [String: String]
    let date: Date
    let httpBody: Data?
    
    init(_ request: URLRequest) {
        httpMethod = request.httpMethod?.uppercased() ?? "GET"
        timeout = Double(request.timeoutInterval)
        httpHeaders = request.allHTTPHeaderFields ?? [:]
        date = Date()
        httpBody = request.httpBody
        
        switch request.cachePolicy {
        case .reloadIgnoringLocalAndRemoteCacheData:
            cachePolicy = "ReloadIgnoringLocalAndRemoteCacheData"
        case .reloadIgnoringLocalCacheData:
            cachePolicy = "ReloadIgnoringLocalCacheData"
        case .reloadRevalidatingCacheData:
            cachePolicy = "ReloadRevalidatingCacheData"
        case .returnCacheDataDontLoad:
            cachePolicy = "ReturnCacheDataDontLoad"
        case .returnCacheDataElseLoad:
            cachePolicy = "ReturnCacheDataElseLoad"
        case .useProtocolCachePolicy:
            cachePolicy = "UseProtocolCachePolicy"
        @unknown default:
            cachePolicy = "Unknown CachePolicy"
        }
        
        if let storagePolicy = URLCache.StoragePolicy(rawValue: request.cachePolicy.rawValue) {
            switch storagePolicy {
            case .allowed:
                self.storagePolicy = "Allow"
            case .allowedInMemoryOnly:
                self.storagePolicy = "AllowedInMemoryOnly"
            case .notAllowed:
                self.storagePolicy = "NotAllowed"
            @unknown default:
                self.storagePolicy = "Unknown StoragePolicy"
            }
        } else {
            storagePolicy = nil
        }
    }
}
