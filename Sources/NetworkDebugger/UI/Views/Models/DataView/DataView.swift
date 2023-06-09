//
//  DataView.swift
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

struct DataView: View {
    let data: Data
    
    var body: some View {
        WebView(
            html: getHtmlContents().replacingOccurrences(of: "{CONTENT}", with: prettyData()),
            script: getScriptContents()
        )
    }
    
    func prettyData() -> String {
        if JSONSerialization.isValidJSONObject(data) {
            let prettyData = try! JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted]);
            return String(data: prettyData, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
        }
        
        let prettyData = String(decoding: data, as: UTF8.self)
        return prettyData
    }
    
    private func getHtmlContents() -> String {
        let css = HighlightjsCss.source
        let html = DataViewHtml.source
        return html.replacingOccurrences(of: "{CSS}", with: css)
    }
    
    private func getScriptContents() -> String {
        let highlightjs = HighlightjsJs.source
        let dataViewJs = DataViewJs.source
        return highlightjs.appending("\n\(dataViewJs)")
    }
}
