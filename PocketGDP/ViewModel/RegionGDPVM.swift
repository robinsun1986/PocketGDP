//
//  RegionGDPVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

class RegionGDPVM {
    let id: String
    let name: String
    var gdp: Double = 0.0
    var countryGDPs = [CountryGDPVM]()
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    func append(_ item: CountryGDPVM) {
        countryGDPs.append(item)
    }
    
    func updateGDP() {
        var gdp = 0.0
        countryGDPs.forEach { gdp += $0.gdp }
        self.gdp = gdp
    }
}

extension RegionGDPVM: Hashable, Equatable {
    static func == (lhs: RegionGDPVM, rhs: RegionGDPVM) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
