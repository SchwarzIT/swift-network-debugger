//
//  ModelView.swift
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

fileprivate enum Page: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case request = "Request"
    case response = "Response"
    
    var id: Self { self }
}

struct ModelView: View {
    @ObservedObject var model: NetworkDebuggerModel
    @State fileprivate var page: Page = .overview
    
    var body: some View {
        VStack {
            Picker("Page", selection: $page) {
                Text("Overview").tag(Page.overview)
                Text("Request").tag(Page.request)
                if model.responseModel != nil || model.error != nil {
                    Text("Response").tag(Page.response)
                }
            }
            .padding(.horizontal, 16)
            .pickerStyle(.segmented)
            currentPage
            Spacer()
        }
    }
    
    @ViewBuilder
    private var currentPage: some View {
        switch page {
        case .overview:
            OverviewView(model: model)
        case .request:
            RequestView(model: model)
        case .response:
            ResponseView(model: model)
        }
    }
}
