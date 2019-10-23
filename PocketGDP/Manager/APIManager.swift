//
//  APIManager.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static var `default`: APIManager {
        return APIManager()
    }
    
    public func request<T: Decodable>(_ endPoint: APIRouter,
                                      completionHandler: @escaping (Response<T>) -> Void) -> Void {
        AF.request(endPoint).responseDecodable { (response: DataResponse<T, AFError>) in
            switch (response.result) {
            case .success(let obj):
                completionHandler(Response.success(obj))
            case .failure(let error):
                completionHandler(Response.error(APIError(message: error.localizedDescription)))
            }
        }
    }
}

extension APIRouter: URLRequestConvertible {
    
}
