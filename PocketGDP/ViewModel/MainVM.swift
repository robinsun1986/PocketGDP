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
    var isLoadingCountry = BehaviorRelay(value: false)
    var isLoadingCountryGDP = BehaviorRelay(value: false)
    var loading = BehaviorRelay(value: false)
    let dataManager: DataManager
    private let disposeBag = DisposeBag()
    var cachedYearResults = [String : [RegionGDPVM]]()
    var displayResults = BehaviorRelay(value: [RegionGDPVM]())
    var currentYearResults = [RegionGDPVM]()
    
    var countryModels = [Country]()
    var countryGDPModels = [CountryGDP]()
    
    init(dataManager: DataManager = DataManager.default) {
        self.dataManager = dataManager

        selectedYearIndex.asDriver().drive(onNext: { [unowned self] yearIndex in

            let selectedYear = self.yearItems[yearIndex]
            
            self.currentYearResults = self.cachedYearResults[selectedYear] ?? [RegionGDPVM]()
            if self.currentYearResults.isEmpty {
                self.fetchAllCountry()
                self.fetchAllCountryGDP()
            } else {
                self.updateDisplayResults()
            }
            
        }).disposed(by: disposeBag)
        
        Driver.combineLatest(isLoadingCountry.asDriver(), isLoadingCountryGDP.asDriver()).drive(onNext: { [unowned self] loadingCountry, loadingCountryGDP in
            
            let loading = loadingCountry || loadingCountryGDP
            self.loading.accept(loading)
            
            if !loading {
                self.populateViewModel()
            }
            
            }).disposed(by: disposeBag)
    }
    
    private func fetchAllCountry() {
        self.isLoadingCountry.accept(true)
        dataManager.fetchAllCountry { response in
            switch(response) {
            case .success(let countries):
                self.countryModels = countries
                self.isLoadingCountry.accept(false)
            case .error(let apiError):
                self.isLoadingCountry.accept(false)
                self.errorMessage.accept(apiError.message)
            }
        }
    }
    
    private func fetchAllCountryGDP() {
        isLoadingCountryGDP.accept(true)
        let year = yearItems[selectedYearIndex.value]
        dataManager.fetchAllCountryGDP(year: year) { response in
            switch(response) {
            case .success(let countryGDPs):
                self.countryGDPModels = countryGDPs
                self.isLoadingCountryGDP.accept(false)
                break
            case .error(let apiError):
                self.isLoadingCountryGDP.accept(false)
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
        
        currentYearResults = Array(regionVMDict.values)
        let year = yearItems[selectedYearIndex.value]
        cachedYearResults[year] = currentYearResults
        updateDisplayResults()
    }
    
    func updateDisplayResults() {
        currentYearResults.forEach {
            $0.updateGDP()
            
            $0.countryGDPs = $0.countryGDPs.sorted { [unowned self] lhs, rhs -> Bool in
                return self.sortGDPEntity(lhs: lhs, rhs: rhs)
            }
        }
        
        let results = currentYearResults.sorted { [unowned self] lhs, rhs -> Bool in
            return self.sortGDPEntity(lhs: lhs, rhs: rhs)
        }
        displayResults.accept(results)
    }
    
    private func sortGDPEntity(lhs: GDPEntityVM, rhs: GDPEntityVM) -> Bool {
        if (selectedSortBy.value == Constants.nameTitle) {
            return lhs.name < rhs.name
        } else {
            return lhs.gdp > rhs.gdp
        }
    }
}
