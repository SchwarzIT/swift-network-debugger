//
//  NetworkDebuggerModel.swift
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

final class NetworkDebuggerModel: Identifiable, ObservableObject {
    let id: UUID
    let url: URL
    var error: Error? {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    var inProgress: Bool
    var time: Float?
    
    let requestModel: RequestModel
    var responseModel: ResponseModel? {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    var responseBody: Data? {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    init(for request: URLRequest) {
        id = UUID()
        url = request.url!
        inProgress = true
        requestModel = RequestModel(request)
    }
    
    func initError(with error: Error) {
        inProgress = false
        self.error = error
    }
    
    func initResponse(_ response: HTTPURLResponse, at date: Date) {
        inProgress = false
        
        let responseModel = ResponseModel(response, at: date)
        self.responseModel = responseModel
        time = Float(responseModel.date.timeIntervalSince(requestModel.date))
    }
    
    func initResponse(body data: Data) {
        responseBody = data
    }
}

extension NetworkDebuggerModel: Equatable {
    static func == (lhs: NetworkDebuggerModel, rhs: NetworkDebuggerModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension NetworkDebuggerModel: Hashable {
    var hashValue: Int {
        ObjectIdentifier(self).hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
