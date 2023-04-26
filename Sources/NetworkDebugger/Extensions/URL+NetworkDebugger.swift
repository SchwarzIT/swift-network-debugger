//
//  URL+NetworkDebugger.swift
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

import Foundation

extension URL {
    var ndHost: String {
        if #available(iOS 16.0, *) {
            return host(percentEncoded: false) ?? "N/A"
        } else {
            return host ?? "N/A"
        }
    }
    
    var ndPath: String {
        if #available(iOS 16.0, *) {
            return path(percentEncoded: false)
        } else {
            return path
        }
    }
}
