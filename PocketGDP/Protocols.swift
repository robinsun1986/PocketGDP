//
//  Protocols.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol DataProtocol {

}

// represent a generic response to an operation request
enum Response<T> {
    case success(_: T)
    case error(ResponseErrorProtocol)
}

protocol ResponseErrorProtocol: Error {
    var message: String { get }
}

enum HttpMethod: String {
    case POST, GET, PUT, DELETE, CONNECT, HEAD, OPTIONS, PATCH
}
