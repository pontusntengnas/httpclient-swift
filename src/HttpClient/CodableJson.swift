//
//  CodableJson.swift
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

public protocol CodableJson: Decodable {
    static var jsonDecoder: JSONDecoder { get }
    init?(json:Data)
}

public extension CodableJson {
    private static var jsonDecoder: JSONDecoder {
        get {
            return JSONDecoder()
        }
    }
    
    init?(json:Data) {
        do {
            self = try Self.self.jsonDecoder.decode(Self.self, from: json)
        } catch {
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }
}
