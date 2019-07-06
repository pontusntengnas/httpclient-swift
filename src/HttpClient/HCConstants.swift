//
//  HCConstants.swift
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

public struct HCConstants {
    
    private init() { }
    
    // Header names
    public static let contentType = "Content-Type"
    public static let authorization = "Authorization"
    public static let accept = "Accept"
    
    // Content Types
    public static let urlEncoded = "application/x-www-form-urlencoded"
    public static let applicationJson = "application/json"
    
    // Authorizations
    static private let _bearer = "Bearer"
    public static func bearer(value: String) -> String {
        return "\(_bearer) \(value)"
    }
    
    static private let _basic = "Basic"
    public static func basic(value: String) -> String {
        return "\(_basic) \(value)"
    }
}
