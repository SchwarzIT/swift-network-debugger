//
//  URLSessionConfiguration+NetworkDebugger.swift
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

extension URLSessionConfiguration {
    
    // MARK: Setter
    
    static func swizzleSetter() {
        let instance = `default`
        let targetClass: AnyClass = object_getClass(instance)!
        
        let originalSEL = #selector(setter: URLSessionConfiguration.protocolClasses)
        let networkDebuggerSEL = #selector(setter: URLSessionConfiguration.networkDebuggerProtocolClasses)
        
        let originalMethod = class_getInstanceMethod(targetClass, originalSEL)!
        let networkDebuggerMethod = class_getInstanceMethod(targetClass, networkDebuggerSEL)!
        method_exchangeImplementations(originalMethod, networkDebuggerMethod)
    }
    
    @objc private dynamic var networkDebuggerProtocolClasses: [AnyClass]? {
        get { return self.networkDebuggerProtocolClasses }
        set {
            guard let protoClasses = newValue else {
                self.networkDebuggerProtocolClasses = nil
                return
            }
            var filteredProtoClasses = [AnyClass]()
            for protoClass in protoClasses {
                if !filteredProtoClasses.contains(where: { $0 == protoClass }) {
                    filteredProtoClasses.append(protoClass)
                }
            }
            self.networkDebuggerProtocolClasses = filteredProtoClasses
        }
    }
    
    // MARK: Default
    
    static func swizzleDefault() {
        let targetClass: AnyClass = object_getClass(URLSessionConfiguration.self)!
        
        let originalSEL = #selector(getter: URLSessionConfiguration.default)
        let networkDebuggerSEL = #selector(getter: URLSessionConfiguration.networkDebuggerDefault)
        
        let originalMethod = class_getClassMethod(targetClass, originalSEL)!
        let networkDebuggerMethod = class_getClassMethod(targetClass, networkDebuggerSEL)!
        method_exchangeImplementations(originalMethod, networkDebuggerMethod)
    }
    
    @objc private dynamic class var networkDebuggerDefault: URLSessionConfiguration {
        get {
            let config = URLSessionConfiguration.networkDebuggerDefault
            if config.protocolClasses == nil {
                config.protocolClasses = [AnyClass]()
            }
            config.protocolClasses?.insert(NetworkDebuggerURLProtocol.self, at: 0)
            return config
        }
    }
    
    // MARK: Ephemeral
    
    static func swizzleEphemeral() {
        let targetClass: AnyClass = object_getClass(URLSessionConfiguration.self)!
        
        let originalSEL = #selector(getter: URLSessionConfiguration.ephemeral)
        let networkDebuggerSEL = #selector(getter: URLSessionConfiguration.networkDebuggerEphemeral)
        
        let originalMethod = class_getClassMethod(targetClass, originalSEL)!
        let networkDebuggerMethod = class_getClassMethod(targetClass, networkDebuggerSEL)!
        method_exchangeImplementations(originalMethod, networkDebuggerMethod)
    }
    
    @objc private dynamic class var networkDebuggerEphemeral: URLSessionConfiguration {
        get {
            let config = URLSessionConfiguration.networkDebuggerEphemeral
            if config.protocolClasses == nil {
                config.protocolClasses = [AnyClass]()
            }
            config.protocolClasses?.insert(NetworkDebuggerURLProtocol.self, at: 0)
            return config
        }
    }
}
