//
//  KeyValue.swift
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

struct KeyValue<Key: View, Value: View>: View {
    private let key: () -> Key
    private let value: () -> Value
    private let overrideColor: Bool
    
    init(@ViewBuilder key: @escaping () -> Key, @ViewBuilder value: @escaping () -> Value, overrideColor: Bool = true) {
        self.key = key
        self.value = value
        self.overrideColor = overrideColor
    }
    
    var body: some View {
        HStack {
            key()
            Spacer()
            if overrideColor {
                value().foregroundColor(.secondary)
            } else {
                value()
            }
        }
    }
}
