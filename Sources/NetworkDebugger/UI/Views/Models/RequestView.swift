//
//  RequestView.swift
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

import SwiftUI

struct RequestView: View {
    @ObservedObject var model: NetworkDebuggerModel
    
    var body: some View {
        List {
            Section {
                KeyValue {
                    Text("HTTP Method")
                } value: {
                    Text(model.requestModel.httpMethod)
                }
                KeyValue {
                    Text("Cache Policy")
                } value: {
                    Text(model.requestModel.cachePolicy)
                }
                if let storagePolicy = model.requestModel.storagePolicy {
                    KeyValue {
                        Text("Storage Policy")
                    } value: {
                        Text(storagePolicy)
                    }
                }
                KeyValue {
                    Text("Timeout")
                } value: {
                    Text("\(model.requestModel.timeout)s")
                }
                KeyValue {
                    Text("Request At")
                } value: {
                    Text(model.requestModel.date.ndFormatted)
                }
            } header: {
                Text("Request")
            }
            Section {
                if model.requestModel.httpHeaders.count > 0 {
                    ForEach(model.requestModel.httpHeaders.sorted(by: >), id: \.key) { key, value in
                        KeyValue {
                            Text(key)
                        } value: {
                            Text(value)
                        }
                    }
                } else {
                    Text("No headers")
                }
            } header: {
                Text("Headers")
            }
            Section {
                if let data = model.requestModel.httpBody {
                    NavigationLink(destination: DataView(data: data)) {
                        Text("See data").foregroundColor(.accentColor)
                    }
                } else {
                    Text("No data")
                }
            } header: {
                Text("Body")
            }
        }
        .listStyle(.sidebar)
    }
}
