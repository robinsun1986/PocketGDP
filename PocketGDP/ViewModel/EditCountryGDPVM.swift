//
//  EditCountryGDPVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 24/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class EditCountryGDPVM {
    
    let countryGDPVM: CountryGDPVM
    let countryName = BehaviorRelay(value: "")
    let countryGDP = BehaviorRelay(value: "")
    let countryNameError = BehaviorRelay(value: "")
    let countryGDPError = BehaviorRelay(value: "")
    private let disposeBag = DisposeBag()
    
    init(countryGDPVM: CountryGDPVM) {
        self.countryGDPVM = countryGDPVM
        countryName.accept(countryGDPVM.name)
        countryGDP.accept(countryGDPVM.gdp.gdpDecimalFormat())
        
        countryName.asDriver().drive(onNext: { [weak self] name in
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self?.countryNameError.accept(Constants.countryNameInvalidError)
            } else {
                self?.countryNameError.accept("")
            }
        }).disposed(by: disposeBag)
        
        countryGDP.asDriver().drive(onNext: { [weak self] gdp in
            if gdp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self?.countryGDPError.accept(Constants.countryGDPInvalidError)
            } else {
                self?.countryGDPError.accept("")
            }
        }).disposed(by: disposeBag)
    }
    
    func isInputValid() -> Bool {
        return countryNameError.value.isEmpty && countryGDPError.value.isEmpty
    }
}
