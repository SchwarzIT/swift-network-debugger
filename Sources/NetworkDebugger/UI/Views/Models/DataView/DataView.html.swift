//
//  DataView.html.swift
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

enum DataViewHtml {
    static let source = #"""
        <!DOCTYPE html>
        <html>
        <head>
            <!-- Highlightjs 11.5.1 styles default.min.css -->
            <style>{CSS}</style>
        </head>
        <body>
            <pre>
                <code id="code" style="font-size: 50px;">{CONTENT}</code>
            </pre>
        </body>
        </html>
    """#
}
