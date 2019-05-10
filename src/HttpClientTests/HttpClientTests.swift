//
//  HttpClientTests.swift
//  HttpClientTests
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import XCTest
@testable import HttpClient

class TestClass: Codable {
    var TestProperty: String
}

class HttpClientTests: XCTestCase {

    func testBadUrl() {
        let client = HttpClient()
        
        client.httpRequest(url: "silly test url", httpMethod: .get, outType: TestClass.self) { (res) in
            if let response = res {
                print(response)
                if case .badInput(let reason) = response {
                    XCTAssertEqual(reason, "Input URL is not valid")
                } else {
                    XCTFail("Did not receive bad input response")
                }
            } else {
                XCTFail("Received a nil response")
            }
        }
    }
    
    func testNilUrl() {
        let client = HttpClient()
        
        client.httpRequest(url: "", httpMethod: .get, outType: TestClass.self){ (response) in
            if let response = response {
                print(response)
                if case .badInput(let reason) = response {
                    XCTAssertEqual(reason, "Url is empty")
                } else {
                    XCTFail("Did not receive bad input response")
                }
            } else {
                XCTFail("Received a nil response")
            }
        }
    }
}
