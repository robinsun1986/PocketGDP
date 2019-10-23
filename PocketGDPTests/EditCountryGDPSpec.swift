//
//  SetPasswordSpec.swift
//  PocketGDP
//
//  Created by Robin Sun on 24/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import XCTest
import Foundation
import Quick
import Nimble
@testable import PocketGDP

class EditCountryGDPSpec: QuickSpec {
    
    // this is where the tests take place
    override func spec() {
        // This is called before the invocation of each test in the class.
        beforeEach {
            
        }
        describe("Validate Input") {
            let countryGDPVM = CountryGDPVM(id: "123", name: "Australia", gdp: 12345678.90)
            let viewModel = EditCountryGDPVM(countryGDPVM: countryGDPVM)
            
            context("No change to the orignal input") {
                it("Input is valid") {
                    expect(viewModel.isInputValid()).to(equal(true))
                    expect(viewModel.countryNameError.value).to(equal(""))
                    expect(viewModel.countryGDPError.value).to(equal(""))
                }
            }
            
            context("Change country name") {
                it("Input is valid") {
                    viewModel.countryName.accept("Aussie")
                    expect(viewModel.isInputValid()).to(equal(true))
                    expect(viewModel.countryNameError.value).to(equal(""))
                    expect(viewModel.countryGDPError.value).to(equal(""))
                }
                
                it("Input is invalid with empty input") {
                    viewModel.countryName.accept("")
                    expect(viewModel.isInputValid()).to(equal(false))
                    expect(viewModel.countryNameError.value).to(equal(Constants.countryNameInvalidError))
                    expect(viewModel.countryGDPError.value).to(equal(""))
                }
                
                it("Input is invalid with spacing input") {
                    viewModel.countryName.accept("     ")
                    expect(viewModel.isInputValid()).to(equal(false))
                    expect(viewModel.countryNameError.value).to(equal(Constants.countryNameInvalidError))
                    expect(viewModel.countryGDPError.value).to(equal(""))
                }
            }
            
            context("Change country GDP") {
                it("Input is valid") {
                    viewModel.countryGDP.accept("987654321.71")
                    expect(viewModel.isInputValid()).to(equal(true))
                    expect(viewModel.countryNameError.value).to(equal(""))
                    expect(viewModel.countryGDPError.value).to(equal(""))
                }
                
                it("Input is invalid with empty input") {
                    viewModel.countryGDP.accept("")
                    expect(viewModel.isInputValid()).to(equal(false))
                    expect(viewModel.countryNameError.value).to(equal(""))
                    expect(viewModel.countryGDPError.value).to(equal(Constants.countryGDPInvalidError))
                }
            }
        }
    }
}

