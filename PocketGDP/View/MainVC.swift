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

        title = Constants.mainTitle
        setupTableView()
    }
    
    func inject(viewModel: MainVM) {
        self.viewModel = viewModel
    }
    
    private func setupTableView() {
        tableViewForResults.dataSource = self
        tableViewForResults.delegate = self
        tableViewForResults.rowHeight = UITableView.automaticDimension
        tableViewForResults.estimatedRowHeight = Constants.resultEstimatedRowHeight
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
