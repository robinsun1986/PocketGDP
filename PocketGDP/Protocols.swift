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

extension Double {
    func gdpFormat() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .currencyAccounting

        var res = ""
        if let formattedGdpAmount = formatter.string(from: self as NSNumber) {
            res = formattedGdpAmount
        }
        return res
    }
}

protocol GDPEntityVM {
    var name: String { get }
    var gdp: Double { get }
}
