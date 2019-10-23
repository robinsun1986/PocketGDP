//
//  MainVM.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class MainVM {
    var yearItems: [String] =
        ["2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008"]

    var selectedYearIndex = BehaviorRelay<Int>(value: 0)
    var selectedSortBy = BehaviorRelay<String>(value: Constants.nameTitle)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var allCountryRefreshed = BehaviorRelay(value: false)
    var allCountryGDPRefreshed = BehaviorRelay(value: false)
    var loading = BehaviorRelay(value: false)
    let dataManager: DataManager
    private let disposeBag = DisposeBag()
    var cachedYearResults = [String : [RegionGDPVM]]()
    var displayResults = BehaviorRelay(value: [RegionGDPVM]())
    
    var countryModels = [Country]()
    var countryGDPModels = [CountryGDP]()
    
    init(dataManager: DataManager = DataManager.default) {
        self.dataManager = dataManager

        selectedYearIndex.asDriver().drive(onNext: { [unowned self] yearIndex in

            let selectedYear = self.yearItems[yearIndex]
            
            let cachedResults = self.cachedYearResults[selectedYear] ?? [RegionGDPVM]()
            if cachedResults.isEmpty {
                self.fetchAllCountry()
                self.fetchAllCountryGDP()
            } else {
                self.updateDisplayResults(cachedResults)
            }
            
        }).disposed(by: disposeBag)
        
        Driver.combineLatest(allCountryRefreshed.asDriver(), allCountryGDPRefreshed.asDriver()).drive(onNext: { [unowned self] countryRefreshed, countryGDPRefreshed in
            
            let loading = !(countryRefreshed && countryGDPRefreshed)
            self.loading.accept(loading)
            
            if !loading {
                self.populateViewModel()
            }
            
            }).disposed(by: disposeBag)
    }
    
    private func fetchAllCountry() {
        self.allCountryRefreshed.accept(false)
        dataManager.fetchAllCountry { response in
            switch(response) {
            case .success(let countries):
                self.allCountryRefreshed.accept(true)
                self.countryModels = countries
                break
            case .error(let apiError):
                self.allCountryRefreshed.accept(true)
                self.errorMessage.accept(apiError.message)
            }
        }
    }
    
    private func fetchAllCountryGDP() {
        allCountryGDPRefreshed.accept(false)
        let year = yearItems[selectedYearIndex.value]
        dataManager.fetchAllCountryGDP(year: year) { response in
            switch(response) {
            case .success(let countryGDPs):
                self.allCountryGDPRefreshed.accept(true)
                self.countryGDPModels = countryGDPs
                break
            case .error(let apiError):
                self.allCountryGDPRefreshed.accept(true)
                self.errorMessage.accept(apiError.message)
            }
        }
    }
    
    private func populateViewModel() {
        var regionVMDict = [String : RegionGDPVM]()
        dataManager.cachedRegions.forEach { regionVMDict[$0.id] = RegionGDPVM(id: $0.id, name: $0.name) }
        
        var countryGDPDict = [String : CountryGDP]()
        countryGDPModels.forEach {
            countryGDPDict[$0.countryId] = $0
        }
        countryModels.forEach {
            if let countryGDP = countryGDPDict[$0.id] {
                let countryGDPVM = CountryGDPVM(id: countryGDP.countryId, name: countryGDP.countryName, gdp: countryGDP.gdp)
                if let regionVM = regionVMDict[$0.region.id] {
                    regionVM.append(countryGDPVM)
                }
            }
        }
        updateDisplayResults(Array(regionVMDict.values))
    }
    
    func updateDisplayResults(_ cachedResults: [RegionGDPVM]) {
        cachedResults.forEach { $0.updateGDP() }
        
        let results = cachedResults.sorted { [unowned self] lhs, rhs -> Bool in
            if (self.selectedSortBy.value == Constants.nameTitle) {
                return lhs.name < rhs.name
            } else {
                return lhs.gdp > rhs.gdp
            }
        }
        displayResults.accept(results)
    }
}
