//
//  UIViewController+NetworkDebugger.swift
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

import UIKit

extension UIViewController {
    static func presentedViewController(_ viewController: UIViewController? = UIApplication.shared.ndKeyWindow?.rootViewController) -> UIViewController? {
        guard let viewController else { return nil }
        
        // MARK: NavigationController
        
        if let navigationController = viewController as? UINavigationController {
            guard let visibleViewController = navigationController.visibleViewController else {
                return presentedViewController(navigationController.topViewController)
            }
            return presentedViewController(visibleViewController)
        }
        
        // MARK: TabbarController
        
        if let tabbarController = viewController as? UITabBarController {
            if tabbarController.selectedIndex >= 4,
               let viewControllers = tabbarController.viewControllers,
               viewControllers.count > 5 {
                return presentedViewController(tabbarController.moreNavigationController)
            }
            return presentedViewController(tabbarController.selectedViewController)
        }
        
        // MARK: Presentation
        
        if let presentedViewController = viewController.presentedViewController {
            return self.presentedViewController(presentedViewController)
        }
        
        if viewController.children.count > 0 {
            return viewController.children.first
        }
        
        return viewController
    }
}
