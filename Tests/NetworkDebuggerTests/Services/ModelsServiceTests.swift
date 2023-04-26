//
//  ModelsServiceTests.swift
//  
//
//  Created by Michael Artes on 03.03.23.
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

import XCTest
@testable import NetworkDebugger

final class ModelsServiceTests: XCTestCase {
    
    // MARK: maxRequests
    
    func testMaxRequests() {
        // Given
        let randomNumber = Int.random(in: 0...100)
        let modelsService = ModelsService()

        XCTAssertTrue(modelsService.models.isEmpty)

        // When
        NetworkDebugger.maxRequests = randomNumber
        
        let url = URL(string: "https://www.jobs.schwarz/")!
        let request = URLRequest(url: url)
        for _ in 0...randomNumber * 2 {
            let model = NetworkDebuggerModel(for: request)
            modelsService.append(model: model)
        }
        
        // Then
        XCTAssertEqual(modelsService.models.count, NetworkDebugger.maxRequests)
    }
}
