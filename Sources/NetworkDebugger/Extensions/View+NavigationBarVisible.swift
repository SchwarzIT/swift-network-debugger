//
//  View+NavigationBarVisible.swift
//  
//
//  Created by Michael Artes on 17.03.23.
//

import SwiftUI

extension View {
    func ensureNavigationBarVisible() -> some View {
        if #available(iOS 15.0, *) {
            return self.safeAreaInset(edge: .top) {
                Color.clear
                    .frame(height: 0)
                    .background(.bar)
                    .border(.black)
            }
        } else {
            return self
        }
    }
}
