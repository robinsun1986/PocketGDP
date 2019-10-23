//
//  DataManagerSpec.swift
//  PocketGDP
//
//  Created by Robin Sun on 24/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import XCTest
import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import PocketGDP

class DataManagerSpec: QuickSpec {
    
    enum CallAPIExpected {
        case allCountryReceived
//        case allCountryGDPReceived
    }
    
    static var callExpected = CallAPIExpected.allCountryReceived
    
    // this is where the tests take place
    override func spec() {
        // This is called before the invocation of each test in the class.
        beforeEach {
            
        }
        describe("Validate API call") {
            let dataManager = DataManager()
            
            context("Perform API call to get all country data") {
                it("Data received successfully") {
                    dataManager.fetchAllCountry { response in
                        switch (response) {
                        case .success(let items):
                            expect(items.count).to(equal(5))
                            expect(items.last?.name).to(equal("Zimbabwe"))
                            expect(items.last?.region.name).to(equal("Sub-Saharan Africa"))
                        case .error:
                            fail()
                        }
                    }
                }
            }
            
            context("Perform API call to get all country GDP data") {
                it("Data received successfully") {
                    dataManager.fetchAllCountryGDP(year: "2018") { response in
                        switch (response) {
                        case .success(let items):
                            expect(items.count).to(equal(5))
                            expect(items.last?.countryId).to(equal("ZW"))
                            expect(items.last?.countryName).to(equal("Zimbabwe"))
                            expect(items.last?.gdp).to(equal(22813010116.1292))
                            expect(items.last?.year).to(equal("2018"))
                        case .error:
                            fail()
                        }
                    }
                }
            }
        }
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

    func stubTest() {
        _ = stub(condition: isMethodGET()) { _ in
            switch DataManagerSpec.callExpected {
            case .allCountryReceived:
                let filePath = Bundle.main.path(forResource: "allCountryResponse", ofType: "json") ?? ""
                return OHHTTPStubsResponse(fileAtPath: filePath, statusCode: 200, headers: nil)
            }
        }
    }
}

