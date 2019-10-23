//
//  DataManager.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import RxSwift

class DataManager: DataProtocol {
    let network: APIManager
    var cachedRegions = [CountryRegion]()
    var cachedCountries = [Country]() {
        didSet {
            var regionsSet = Set<CountryRegion>()
            cachedCountries.forEach { regionsSet.insert($0.region) }
            cachedRegions = Array(cachedRegions)
        }
    }
    
    init(network: APIManager = APIManager.default) {
        self.network = network
    }
    
    func fetchAllCountryGDP(year: String, completion: @escaping (_ response: Response<[CountryGDP]>) -> Void) {
        let router = APIRouter.allCountryGDP(year: year)
        network.request(router) { (response: Response<AllCountryGDPResponse>) -> Void in
            switch response {
            case .success(let res):
                completion(.success(res.items))
            case .error(let error):
                completion(.error(APIError(message: error.localizedDescription)))
            }
        }
    }
    
    func fetchAllCountry(completion: @escaping (_ response: Response<[Country]>) -> Void) {
        network.request(APIRouter.allCountry) { [weak self] (response: Response<AllCountryResponse>) -> Void in
            switch response {
            case .success(let res):
                self?.cachedCountries = res.items
                completion(.success(res.items))
            case .error(let error):
                completion(.error(APIError(message: error.localizedDescription)))
            }
        }
    }
}
