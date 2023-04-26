//
//  SettingsView.swift
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

struct SettingsView: View {
    @EnvironmentObject var modelsService: ModelsService
    @EnvironmentObject var settingsService: SettingsService
    
    private var methods: [String] {
        modelsService.models
            .map { $0.requestModel.httpMethod }
            .unique()
    }
    
    private var hosts: [String] {
        modelsService.models
            .compactMap { $0.url.ndHost }
            .unique()
    }
    
    var body: some View {
        List {
            if modelsService.models.count > 0 {
                Section {
                    ForEach(methods, id: \.self) { method in
                        ToggleCallbackView(initialState: !settingsService.hiddenMethods.contains(method)) {
                            Text(method.uppercased())
                        } onChange: { newState in
                            if newState {
                                settingsService.hiddenMethods.removeAll(where: { $0 == method })
                            } else {
                                settingsService.hiddenMethods.append(method)
                            }
                        }
                    }
                } header: {
                    Text("Filter Methods")
                } footer: {
                    Text("By deselecting methods, you are filtering out all requests using that specific method.")
                }
                Section {
                    ForEach(hosts, id: \.self) { host in
                        ToggleCallbackView(initialState: !settingsService.hiddenHosts.contains(host)) {
                            Text(host)
                        } onChange: { newState in
                            if newState {
                                settingsService.hiddenHosts.removeAll(where: { $0 == host })
                            } else {
                                settingsService.hiddenHosts.append(host)
                            }
                        }
                    }
                } header: {
                    Text("Filter Hosts")
                } footer: {
                    Text("By deselecting hosts, you are filtering out all requests towards that specific host.")
                }
            }
            if NetworkDebugger.ignoredHosts.count > 0 {
                Section {
                    ForEach(NetworkDebugger.ignoredHosts, id: \.self) { ignoredHost in
                        Text(ignoredHost)
                    }
                } header: {
                    Text("Ignored Hosts")
                } footer: {
                    Text("This list of ignored hosts has been defined by the developer and cannot be changed. Requests towards these hosts will not be recorded.")
                }
            }
            if modelsService.models.count == 0 && NetworkDebugger.ignoredHosts.count == 0 {
                Text("There's nothing here (yet)")
            }
        }
        .ensureNavigationBarVisible()
    }
}
