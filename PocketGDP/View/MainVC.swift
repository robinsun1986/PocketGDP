//
//  MainVC.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import RxSwift
import RxCocoa
import SVProgressHUD

protocol MainVCDelegate: class {
    func requestToEditCountryGDP(countryGDPVM: CountryGDPVM)
}

class MainVC: UIViewController {
    
    @IBOutlet weak var labelForYear: UILabel!
    @IBOutlet weak var labelForSorting: UILabel!
    @IBOutlet weak var tableViewForResults: UITableView!
    
    weak var delegate: MainVCDelegate?
    var viewModel: MainVM!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil)
        setupUI()
        setupBinding()
    }
    
    func inject(viewModel: MainVM) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        title = Constants.mainTitle
        labelForYear.text = Constants.yearTitle
        labelForSorting.text = Constants.sortByTitle
        
        tableViewForResults.tableFooterView = UIView()
        tableViewForResults.dataSource = self
        tableViewForResults.delegate = self
        tableViewForResults.rowHeight = UITableView.automaticDimension
        tableViewForResults.estimatedRowHeight = Constants.resultEstimatedRowHeight
        tableViewForResults.register(UINib(nibName: Constants.countryGDPCellId, bundle: nil), forCellReuseIdentifier: Constants.countryGDPCellId)
        tableViewForResults.sectionHeaderHeight = UITableView.automaticDimension
        tableViewForResults.estimatedSectionHeaderHeight = Constants.regionSecionHeaderViewHeight
        tableViewForResults.register(UINib(nibName: Constants.regionSectionHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.regionSectionHeaderView)
    }
    
    private func setupBinding() {
        viewModel.selectedYearIndex.asDriver().drive(onNext: { [weak self] yearIndex in
            self?.labelForYear.text = self?.viewModel.yearItems[yearIndex]
        }).disposed(by: disposeBag)
        
        viewModel.selectedSortBy.asDriver().drive(onNext: { [weak self] sortBy in
            self?.labelForSorting.text = sortBy
            self?.viewModel.updateDisplayResults()
        }).disposed(by: disposeBag)
        
        viewModel.loading.asDriver().drive(onNext: { val in
            if val {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        viewModel.displayResults.asDriver().drive(onNext: { [weak self] sortBy in
            self?.tableViewForResults.reloadData()
            DispatchQueue.main.async { [weak self] in
                self?.tableViewForResults.setContentOffset(.zero, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func yearAction(_ sender: Any) {
        ActionSheetMultipleStringPicker.show(withTitle: Constants.selectYearTitle, rows: [
            viewModel.yearItems], initialSelection: [viewModel.selectedYearIndex.value], doneBlock: { [weak self]
                picker, indexes, values in
                
                guard let index = (indexes as? [Int])?.first else { return }
                self?.viewModel.selectedYearIndex.accept(index)

        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func sortByAction(_ sender: Any) {
        // NOTE: When the action sheet shows up, there are some constraint warnings printed in the console. It seems to be a bug with iOS 12.2+.
        // https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
        let alertController = UIAlertController(title: Constants.sortByTitle, message: "", preferredStyle: .actionSheet)

        let nameAction = UIAlertAction(title: Constants.nameTitle, style: .default, handler: { [weak self] (alert: UIAlertAction!) -> Void in
          
            guard let title = alert.title else { return }
            self?.viewModel.selectedSortBy.accept(title)
        })

        let gdpAction = UIAlertAction(title: Constants.GDPTitle, style: .default, handler: { [weak self] (alert: UIAlertAction!) -> Void in
            
            guard let title = alert.title else { return }
            self?.viewModel.selectedSortBy.accept(title)
        })

        let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
          //  leave it empty
        })

        alertController.addAction(nameAction)
        alertController.addAction(gdpAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDelegate
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.displayResults.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let regionVM = viewModel.displayResults.value[section]
        return regionVM.countryGDPs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.countryGDPCellId, for: indexPath) as! CountryGDPCell
        let regionVM = viewModel.displayResults.value[indexPath.section]
        let countryGDPVM = regionVM.countryGDPs[indexPath.row]
        cell.configure(countryGDPVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regionVM = viewModel.displayResults.value[indexPath.section]
        let countryGDPVM = regionVM.countryGDPs[indexPath.row]
        delegate?.requestToEditCountryGDP(countryGDPVM: countryGDPVM)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let regionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.regionSectionHeaderView) as! RegionGDPSectionHeaderView
        let regionVM = viewModel.displayResults.value[section]
        regionHeaderView.configure(regionVM)
        return regionHeaderView
    }
}
