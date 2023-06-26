//
//  DataView.js.swift
//
//
//  Created by Michael Artes on 26.06.23.
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

enum DataViewJs {
    static let source = #"""
        function isJson(str) {
            try { JSON.parse(str) }
            catch(e) { return false; }
            return true;
        }
        
        function makeJSONPretty() {
            const code = document.getElementById("code");
            const codeText = code.textContent;
            if (!isJson(codeText)) return;
            const codeJson = JSON.parse(codeText);
            const prettyJson = JSON.stringify(codeJson, null, 4);
            code.textContent = prettyJson;
        }
        
        makeJSONPretty();
        hljs.highlightAll();
    """#
}
