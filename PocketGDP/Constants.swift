//
//  Constants.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let mainTitle = "GDP by Country"
    static let yearTitle = "Year"
    static let sortByTitle = "Sort by"
    static let nameTitle = "Name"
    static let GDPTitle = "GDP"
    static let cancelTitle = "Cancel"
    static let selectYearTitle = "Select Year"
    static let resultEstimatedRowHeight: CGFloat = 210
    static let countryGDPCellId = "CountryGDPCell"
    static let regionSectionHeaderView = "RegionGDPSectionHeaderView"
    static let regionSecionHeaderViewHeight: CGFloat = 120
    
    static let criteriaButtonHighlightColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
    static let baseURL = "https://api.worldbank.org/v2"
    static let httpHeaderContentType = "Content-Type"
    static let httpHeaderAccept = "Accept"
    static let httpApplicationJson = "application/json"
}
