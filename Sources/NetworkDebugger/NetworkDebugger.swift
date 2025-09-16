//
//  NetworkDebugger.swift
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
import SwiftUI
import UIKit

internal enum Constants {
    static let flag = "com.schwarzit.networkdebugger"
}

@objc public final class NetworkDebugger: NSObject {

    /**
     Determines if NetworkDebugger will respond to shake gestures.
     */
    @objc public static var shakeEnabled = true

    /**
     Determines the amount of requests NetworkDebugger will hold before starting to drop old ones.
     */
    @objc public static var maxRequests = 100

    /**
     Determines the hosts that NetworkDebugger will completely ignore.
     */
    @objc public static var ignoredHosts = [String]()

    @objc public internal(set) static var started = false

    /**
     Starts NetworkDebugger and swizzles it into `URLSessionConfiguration` and `URLSession`.
     
     Do not call this method in any release builds! Use following macro:
     ```
     #if DEBUG
     NetworkDebugger.start()
     #endif
     ```
     
     - Important: Call the method as the first thing in applicationDidFinishLaunching!
     */
    @objc public static func start() {
        guard !started else { return }
        started = true
        URLProtocol.registerClass(NetworkDebuggerURLProtocol.self)
        swizzleNetworkDebugger()
    }

    private static func swizzleNetworkDebugger() {
        URLSessionConfiguration.swizzleSetter()
        URLSessionConfiguration.swizzleDefault()
        URLSessionConfiguration.swizzleEphemeral()
        URLSession.swizzleShared()
    }

    /**
     Attempts to present NetworkDebugger on the top most ViewController.
     */
    @objc public static func presentNetworkDebugger() {
        guard let viewController = UIViewController.presentedViewController() else { return }
        return presentNetworkDebugger(on: viewController)
    }
    
    /**
     Presents NetworkDebugger on the provided ViewController.
     
     - Parameters:
        - viewController: The ViewController to display NetworkDebugger on.
     */
    @objc public static func presentNetworkDebugger(on viewController: UIViewController) {
        guard started,
              viewController.presentedViewController == nil,
              !(viewController is UIHostingController<NetworkDebuggerView>)
        else { return }
        
        let networkDebuggerViewController = UIHostingController(rootView: NetworkDebuggerView())
        viewController.present(networkDebuggerViewController, animated: true)
    }
}
