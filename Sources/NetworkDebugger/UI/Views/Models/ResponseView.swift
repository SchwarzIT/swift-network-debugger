//
//  ResponseView.swift
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

struct ResponseView: View {
    @ObservedObject var model: NetworkDebuggerModel
    
    var body: some View {
        List {
            if let error = model.error {
                KeyValue {
                    Text("Error")
                } value: {
                    Text(error.localizedDescription)
                }
            }
            
            if let response = model.responseModel {
                Section {
                    KeyValue {
                        Text("Status Code")
                    } value: {
                        Text("\(response.statusCode)")
                    }
                    KeyValue {
                        Text("Response At")
                    } value: {
                        Text(response.date.ndFormatted)
                    }
                    if let time = model.time {
                        KeyValue {
                            Text("Duration")
                        } value: {
                            Text("\(String(format: "%.0f", time * 1000))ms")
                        }
                    }
                } header: {
                    Text("Response")
                }
                Section {
                    if response.headers.count > 0 {
                        ForEach(response.headers.sorted(by: >), id: \.key) { key, value in
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
                    if let data = model.responseBody {
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
        }
        .listStyle(.sidebar)
    }
}
