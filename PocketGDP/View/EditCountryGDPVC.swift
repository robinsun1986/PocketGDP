//
//  EditCountryGDPVC.swift
//  PocketGDP
//
//  Created by Robin Sun on 24/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol EditCountryGDPVCDelegate: class {
    func didCountryGDPUpdate()
}

class EditCountryGDPVC: UIViewController {
    
    @IBOutlet weak var textFieldForCountryName: UITextField!
    @IBOutlet weak var labelForCountryNameError: UILabel!
    @IBOutlet weak var textFieldForCountryGDP: UITextField!
    @IBOutlet weak var labelForCountryGDPError: UILabel!
    @IBOutlet weak var buttonForDone: UIButton!
    
    weak var delegate: EditCountryGDPVCDelegate?
    var viewModel: EditCountryGDPVM!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil)
        setupUI()
        setupBinding()
    }
    
    func inject(viewModel: EditCountryGDPVM) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        title = Constants.editCountryGDPTitle
        buttonForDone.setTitle(Constants.doneTitle, for: UIControl.State.normal)
        textFieldForCountryName.text = viewModel.countryGDPVM.name
        textFieldForCountryGDP.text = viewModel.countryGDPVM.gdp.gdpDecimalFormat()
        labelForCountryNameError.text = ""
        labelForCountryGDPError.text = ""
    }
    
    private func setupBinding() {
        textFieldForCountryName.rx.text.orEmpty.asDriver().drive(viewModel.countryName).disposed(by: disposeBag)
        textFieldForCountryGDP.rx.text.orEmpty.asDriver().drive(viewModel.countryGDP).disposed(by: disposeBag)

        textFieldForCountryName.rx.controlEvent(UIControl.Event.editingDidEnd).asDriver()
            .withLatestFrom(viewModel.countryNameError.asDriver()) { ($0, $1) }.map { $1 }
            .drive(labelForCountryNameError.rx.text).disposed(by: disposeBag)
        textFieldForCountryGDP.rx.controlEvent(UIControl.Event.editingDidEnd).asDriver()
            .withLatestFrom(viewModel.countryGDPError.asDriver()) { ($0, $1) }.map { $1 }
            .drive(labelForCountryGDPError.rx.text).disposed(by: disposeBag)
    }
    
    @IBAction func doneAction() {
        textFieldForCountryName.sendActions(for: UIControl.Event.editingDidEnd)
        textFieldForCountryGDP.sendActions(for: UIControl.Event.editingDidEnd)
        guard viewModel.isInputValid() else { return }
        
        viewModel.countryGDPVM.name = viewModel.countryName.value
        viewModel.countryGDPVM.gdp = Double(viewModel.countryGDP.value) ?? 0.0
        delegate?.didCountryGDPUpdate()
    }
}
