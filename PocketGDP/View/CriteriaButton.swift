//
//  CriteriaButton.swift
//  PocketGDP
//
//  Created by Robin Sun on 23/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit

class CriteriaButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.criteriaButtonHighlightColor : UIColor.clear
        }
    }
}
