//
//  MainVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MainVM {
    var yearItems: [String] =
        ["2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008"]

    var selectedYearIndex = BehaviorRelay<Int>(value: 0)
    var selectedSortBy = BehaviorRelay<String>(value: Constants.nameTitle)
    let network: APIManager
    
    init(network: APIManager = APIManager.default) {
        self.network = network
    }
}
