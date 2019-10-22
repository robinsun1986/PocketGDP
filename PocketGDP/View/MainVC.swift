//
//  MainVC.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var labelForYear: UILabel!
    @IBOutlet weak var labelForSorting: UILabel!
    @IBOutlet weak var tableViewForResults: UITableView!
    
    var viewModel: MainVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    @IBAction func yearAction() {
    }
    
    @IBAction func sortByAction(_ sender: Any) {
        // NOTE: When the action sheet shows up, there are some constraint warnings printed in the console. It seems to be a bug with iOS 12.2+.
        // https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
        let alertController = UIAlertController(title: Constants.sortByTitle, message: "", preferredStyle: .actionSheet)

        let nameAction = UIAlertAction(title: Constants.nameTitle, style: .default, handler: { (alert: UIAlertAction!) -> Void in
          // TODO sort by name
        })

        let gdpAction = UIAlertAction(title: Constants.GDPTitle, style: .default, handler: { (alert: UIAlertAction!) -> Void in
          // TODO sort by GDP
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

// MARK: UITableViewDelegate
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
