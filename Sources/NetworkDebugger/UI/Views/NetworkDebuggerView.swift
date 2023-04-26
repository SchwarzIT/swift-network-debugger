//
//  NetworkDebuggerView.swift
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

import SwiftUI

public struct NetworkDebuggerView: View {
    @StateObject var modelsService = ModelsService.shared
    @StateObject var settingsService = SettingsService.shared
    @StateObject var statisticsService = StatisticsService.shared
    
    @State var isSettingsPresented = false
    @State var isStatisticsPresented = false
    @State var searchText = ""
    
    public init() { }
    
    public var body: some View {
        NavigationStack {
            ModelsView(searchText: $searchText)
                .navigationTitle("Network Debugger")
                .sheet(isPresented: $isSettingsPresented) {
                    NavigationStack {
                        SettingsView()
                            .navigationTitle("Settings")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button("Done") {
                                        isSettingsPresented = false
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $isStatisticsPresented) {
                    if #available(iOS 16.0, *) {
                        NavigationStack {
                            StatisticsView()
                                .navigationTitle("Statistics")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .primaryAction) {
                                        Button("Done") {
                                            isStatisticsPresented = false
                                        }
                                    }
                                }
                        }
                    }
                }
                .toolbar {
                    isSettingsPresented = true
                } statistics: {
                    isStatisticsPresented = true
                }
                .ensureNavigationBarVisible()
        }
        .environmentObject(modelsService)
        .environmentObject(settingsService)
        .environmentObject(statisticsService)
        .searchable(searchText: $searchText)
    }
}

private extension View {
    func toolbar(settings: @escaping () -> Void, statistics: @escaping () -> Void) -> some View {
        if #available(iOS 16.0, *) {
            return self.toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Settings") {
                        settings()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Statistics") {
                        statistics()
                        
                    }
                }
            }
        } else {
            return self.toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Settings") {
                        settings()
                    }
                }
            }
        }
    }
}
