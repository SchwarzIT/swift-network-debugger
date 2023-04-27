//
//  Bundle+NetworkDebugger.swift
//
//
//  Created by Michael Artes on 26.04.23.
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

extension Bundle {
    private static let spmBundle: Bundle? = {
        let bundleName = "NetworkDebugger_NetworkDebugger"
        
        let overrides: [URL]
        #if DEBUG
        if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"] {
            overrides = [URL(fileURLWithPath: override)]
        } else {
            overrides = []
        }
        #else
        overrides = []
        #endif
        
        let candidates = overrides + [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: NetworkDebugger.self).resourceURL,
            
            // For command-line tools.
            Bundle.main.bundleURL,
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        return nil
    }()
    
    private static let podsBundle: Bundle? = {
        guard let bundleUrl = Bundle(for: NetworkDebugger.self).url(
                forResource: "NetworkDebugger",
                withExtension: "bundle"
            ),
              let bundle = Bundle(url: bundleUrl)
        else { return nil }
        debugPrint("Debug: \(bundleUrl.absoluteString)")
        return bundle
    }()
    
    static let ndBundle: Bundle = {
        if let spmBundle {
            return spmBundle
        }
        if let podsBundle {
            return podsBundle
        }
        fatalError("Unable to find bundle for NetworkDebugger.")
    }()
}
