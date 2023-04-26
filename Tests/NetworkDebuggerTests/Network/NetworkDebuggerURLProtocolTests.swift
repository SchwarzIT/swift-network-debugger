//
//  NetworkDebuggerURLProtocolTests.swift
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

final class NetworkDebuggerURLProtocolTests: XCTestCase {
    
    private let host = "jobs.schwarz"
    
    // MARK: http
    
    func testHTTP() {
        // Given
        let httpURL = URL(string: "http://\(host)")!
        let httpsURL = URL(string: "https://\(host)")!
        let smbURL = URL(string: "smb://\(host)")!
        
        let httpRequest = URLRequest(url: httpURL)
        let httpsRequest = URLRequest(url: httpsURL)
        let smbRequest = URLRequest(url: smbURL)
        
        // When
        NetworkDebugger.started = true
        
        // Then
        XCTAssertTrue(NetworkDebuggerURLProtocol.canInit(with: httpRequest))
        XCTAssertTrue(NetworkDebuggerURLProtocol.canInit(with: httpsRequest))
        XCTAssertFalse(NetworkDebuggerURLProtocol.canInit(with: smbRequest))
    }
    
    // MARK: ignoredHosts
    
    func testIgnoredHosts() {
        // Given
        let url = URL(string: "https://\(host)")!
        let request = URLRequest(url: url)
        
        NetworkDebugger.started = true
        XCTAssertTrue(NetworkDebuggerURLProtocol.canInit(with: request))
        
        // When
        NetworkDebugger.ignoredHosts = [host]
        
        // Then
        XCTAssertFalse(NetworkDebuggerURLProtocol.canInit(with: request))
    }
}
