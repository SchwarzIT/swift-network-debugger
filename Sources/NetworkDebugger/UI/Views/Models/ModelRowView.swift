//
//  ModelRowView.swift
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

struct ModelRowView: View {
    @EnvironmentObject var modelsService: ModelsService
    @EnvironmentObject var settingsService: SettingsService
    @ObservedObject var model: NetworkDebuggerModel
    
    var body: some View {
        NavigationLink(destination: ModelView(model: model).navigationTitle(model.url.ndHost).navigationBarTitleDisplayMode(.inline)) {
            HStack {
                VStack {
                    Text(model.requestModel.date.ndFormatted)
                    if let time = model.time {
                        Text("\(String(format: "%.0f", time * 1000))ms")
                    } else {
                        Text("---")
                    }
                }
                VStack {
                    Text(model.requestModel.httpMethod.uppercased())
                    statusCode
                }
                Text("\(model.url.absoluteString)")
            }
        }
        .contextMenu {
            Button {
                settingsService.hiddenHosts.append(model.url.ndHost)
            } label: {
                Label("Ignore this host", systemImage: "eye.slash.fill")
            }
            Button {
                settingsService.hiddenMethods.append(model.requestModel.httpMethod.uppercased())
            } label: {
                Label("Ignore \(model.requestModel.httpMethod.uppercased()) methods", systemImage: "eye.slash.fill")
            }
            Divider()
            Button {
                modelsService.models
                    .compactMap { $0.url.ndHost }
                    .unique()
                    .filter { $0 != model.url.ndHost }
                    .filter { !settingsService.hiddenHosts.contains($0) }
                    .forEach { settingsService.hiddenHosts.append($0) }
            } label: {
                Label("Only show this host", systemImage: "eye.fill")
            }
            let method = model.requestModel.httpMethod.uppercased()
            Button {
                modelsService.models
                    .compactMap { $0.requestModel.httpMethod.uppercased() }
                    .unique()
                    .filter { $0 != method }
                    .filter { !settingsService.hiddenMethods.contains($0) }
                    .forEach { settingsService.hiddenMethods.append($0) }
            } label: {
                Label("Only show \(method) methods", systemImage: "eye.fill")
            }
        }
    }
    
    private var statusCodeColor: Color {
        if let response = model.responseModel {
            if response.statusCode < 300 {
                return .green
            } else {
                return .red
            }
        } else {
            return .primary
        }
    }
    
    @ViewBuilder
    private var statusCode: some View {
        if let response = model.responseModel {
            Text("\(response.statusCode)").foregroundColor(statusCodeColor)
        } else {
            Text("---").foregroundColor(statusCodeColor)
        }
    }
}
