//
//  APIManager.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import UIKit

enum APIRouter {
    
    case allCountryGDP(year: String)
    case allCountry
    
    // MARK: - HTTPMethod
    private var method: HttpMethod {
        switch self {
        case .allCountryGDP, .allCountry:
            return .GET
        }
    }
    
    // MARK: - Query
    private var query: [String : String]? {
        switch self {
        case .allCountryGDP(let year):
            return ["format": "json", "per_page": "500", "date" : year]
        case .allCountry:
            return ["format": "json", "per_page": "500"]
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .allCountryGDP:
            return "/country/all/indicator/NY.GDP.MKTP.CD"
        case .allCountry:
            return "/country/all"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        // path
        var url = try Constants.baseURL.asURL()
        url = url.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        // query
        if let query = query {
            urlComponents.queryItems = query.map { (key: String, value: String) -> URLQueryItem in
                URLQueryItem(name: key, value: value)
            }
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
