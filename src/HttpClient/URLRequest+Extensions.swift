//
//  URLRequest+Extensions.swift
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

extension URLRequest {

    mutating func appendHeaders(headers: [String: String]) -> Void {
        for (headerName, headerValue) in headers {
            self.addValue(headerValue, forHTTPHeaderField: headerName)
        }
    }
}
