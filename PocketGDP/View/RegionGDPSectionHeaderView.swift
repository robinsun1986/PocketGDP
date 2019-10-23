//
//  RegionGDPSectionHeaderView.swift
//  PocketGDP
//
//  Created by Robin Sun on 24/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit

class RegionGDPSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var labelForName: UILabel!
    @IBOutlet weak var labelForGDP: UILabel!
    
    var viewModel: RegionGDPVM!
    
    func configure(_ viewModel: RegionGDPVM) {
        self.viewModel = viewModel
        
        labelForName.text = viewModel.name
        labelForGDP.text = viewModel.gdp.gdpCurrencyFormat()
    }
}
