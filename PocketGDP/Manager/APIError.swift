//
//  APIError.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

struct APIError: ResponseErrorProtocol {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
