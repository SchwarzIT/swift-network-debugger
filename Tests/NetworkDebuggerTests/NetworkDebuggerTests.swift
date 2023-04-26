//
//  NetworkDebuggerTests.swift
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

final class NetworkDebuggerTests: XCTestCase {
    
    // MARK: URLSessionConfiguration
    
    func testURLSessionConfigurationSwizzleSetter() {
        // Given
        var config = URLSessionConfiguration.default
        XCTAssertNotNil(config.protocolClasses)
        
        config.protocolClasses!.append(NetworkDebuggerURLProtocol.self)
        config.protocolClasses!.append(NetworkDebuggerURLProtocol.self)
        XCTAssertEqual(config.protocolClasses!.filter { $0 == NetworkDebuggerURLProtocol.self }.count, 2)
        
        // When
        URLSessionConfiguration.swizzleSetter()
        config = URLSessionConfiguration.default
        XCTAssertNotNil(config.protocolClasses)
        
        config.protocolClasses!.append(NetworkDebuggerURLProtocol.self)
        config.protocolClasses!.append(NetworkDebuggerURLProtocol.self)
        XCTAssertEqual(config.protocolClasses!.filter { $0 == NetworkDebuggerURLProtocol.self }.count, 1)
        
        // Undo swizzle for other tests
        URLSessionConfiguration.swizzleSetter()
    }
    
    func testURLSessionConfigurationSwizzleDefault() {
        // Given
        var defaultConfig = URLSessionConfiguration.default
        XCTAssertNotNil(defaultConfig.protocolClasses)
        XCTAssertFalse(defaultConfig.protocolClasses!.contains(where: { $0 == NetworkDebuggerURLProtocol.self }))
        
        // When
        URLSessionConfiguration.swizzleDefault()
        
        // Then
        defaultConfig = URLSessionConfiguration.default
        XCTAssertNotNil(defaultConfig.protocolClasses)
        XCTAssertTrue(defaultConfig.protocolClasses!.contains(where: { $0 == NetworkDebuggerURLProtocol.self }))
        
        // Undo swizzle for other tests
        URLSessionConfiguration.swizzleDefault()
    }
    
    func testURLSessionConfigurationSwizzleEphermal() {
        // Given
        var ephermalConfig = URLSessionConfiguration.ephemeral
        XCTAssertNotNil(ephermalConfig.protocolClasses)
        XCTAssertFalse(ephermalConfig.protocolClasses!.contains(where: { $0 == NetworkDebuggerURLProtocol.self }))
        
        // When
        URLSessionConfiguration.swizzleEphemeral()
        
        // Then
        ephermalConfig = URLSessionConfiguration.ephemeral
        XCTAssertNotNil(ephermalConfig.protocolClasses)
        XCTAssertTrue(ephermalConfig.protocolClasses!.contains(where: { $0 == NetworkDebuggerURLProtocol.self }))
        
        // Undo swizzle for other tests
        URLSessionConfiguration.swizzleEphemeral()
    }
}
