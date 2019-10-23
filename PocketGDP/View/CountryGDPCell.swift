//
//  CountryGDPCell.swift
//  PocketGDP
//
//  Created by Zhihui Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit

class CountryGDPCell: UITableViewCell {

    @IBOutlet weak var labelForCountryName: UILabel!
    @IBOutlet weak var labelForGDP: UILabel!
    
    var viewModel: CountryGDPVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ viewModel: CountryGDPVM) {
        self.viewModel = viewModel
        
        labelForCountryName.text = viewModel.name
        labelForGDP.text = viewModel.gdp.gdpFormat()
    }
}
