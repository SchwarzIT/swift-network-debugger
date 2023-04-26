//
//  OverviewView.swift
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

struct OverviewView: View {
    @ObservedObject var model: NetworkDebuggerModel
    
    var body: some View {
        List {
            Section {
                KeyValue {
                    Text("Scheme")
                } value: {
                    Text(model.url.scheme ?? "N/A")
                }
                KeyValue {
                    Text("Host")
                } value: {
                    Text(model.url.ndHost)
                }
                if model.url.ndPath != "" {
                    KeyValue {
                        Text("Path")
                    } value: {
                        Text(model.url.ndPath)
                    }
                }
            } header: {
                Text("URL")
            }
            Section {
                KeyValue {
                    Text("In Progress")
                } value: {
                    Text(model.inProgress ? "Yes" : "No")
                }
            } header: {
                Text("General")
            }
        }
        .listStyle(.sidebar)
    }
}
