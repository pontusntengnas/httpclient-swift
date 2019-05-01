//
//  HCClientResponse
//  HttpClient
//
//  Created by Pontus Nilsson Tengnäs on 2019-05-01.
//  Copyright © 2019 Pontus Nilsson Tengnäs. All rights reserved.
//

import Foundation

public enum HCClientResponse {
    case success(Int, Data)
    case httpFailure(Int)
    case failure(String)
    case badInput(String)
}
