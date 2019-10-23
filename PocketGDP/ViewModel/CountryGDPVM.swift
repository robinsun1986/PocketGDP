//
//  CountryGDPVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

class CountryGDPVM {
    let id: String
    let name: String
    let gdp: Double
    
    init(id: String, name: String, gdp: Double) {
        self.id = id
        self.name = name
        self.gdp = gdp
    }
}
