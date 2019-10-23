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

class MainVC: UIViewController {
    
    @IBOutlet weak var labelForYear: UILabel!
    @IBOutlet weak var labelForSorting: UILabel!
    @IBOutlet weak var tableViewForResults: UITableView!
    
    var viewModel: MainVM!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        tableViewForResults.dataSource = self
        tableViewForResults.delegate = self
        tableViewForResults.rowHeight = UITableView.automaticDimension
        tableViewForResults.estimatedRowHeight = Constants.resultEstimatedRowHeight
    }
    
    private func setupBinding() {
        viewModel.selectedYearIndex.asDriver().drive(onNext: { [weak self] yearIndex in
            self?.labelForYear.text = self?.viewModel.yearItems[yearIndex]
        }).disposed(by: disposeBag)
        
        viewModel.selectedSortBy.asDriver().drive(onNext: { [weak self] sortBy in
            self?.labelForSorting.text = sortBy
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
