//
//  CountryGDPVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation

class CountryGDPVM: GDPEntityVM {
    let id: String
    var name: String
    var gdp: Double
    
    init(id: String, name: String, gdp: Double) {
        self.id = id
        self.name = name
        self.gdp = gdp
    }
}
