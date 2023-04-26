//
//  URLSession+NetworkDebugger.swift
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

import Foundation

extension URLSession {
    
    // MARK: Shared
    
    static func swizzleShared() {
        let targetClass: AnyClass = object_getClass(URLSession.self)!
        
        let originalSEL = #selector(getter: URLSession.shared)
        let networkDebuggerSEL = #selector(getter: URLSession.networkDebuggerShared)
        
        let originalMethod = class_getClassMethod(targetClass, originalSEL)!
        let networkDebuggerMethod = class_getClassMethod(targetClass, networkDebuggerSEL)!
        method_exchangeImplementations(originalMethod, networkDebuggerMethod)
    }
    
    @objc private dynamic class var networkDebuggerShared: URLSession {
        get {
            let shared = self.networkDebuggerShared
            let session = URLSession(configuration: .default, delegate: shared.delegate, delegateQueue: shared.delegateQueue)
            return session
        }
    }
}
