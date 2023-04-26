//
//  ToggleCallbackView.swift
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

struct ToggleCallbackView<Label: View>: View {
    typealias OnChangeCallback = (Bool) -> Void
    
    private let onChange: OnChangeCallback
    private let label: () -> Label
    
    @State private var isOn: Bool
    
    init(initialState: Bool, @ViewBuilder label: @escaping () -> Label, onChange: @escaping OnChangeCallback) {
        self.onChange = onChange
        self.label = label
        self.isOn = initialState
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
            label()
        }
        .onChange(of: isOn) { newIsOn in
            onChange(newIsOn)
        }
    }
}
