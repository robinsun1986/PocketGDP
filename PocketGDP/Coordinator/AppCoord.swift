//
//  AppCoord.swift
//  PocketGDP
//
//  Created by Robin Sun on 22/10/19.
//  Copyright © 2019 Robin Sun. All rights reserved.
//

import UIKit

class AppCoord {
    private var window: UIWindow?
    private let navigationController: UINavigationController
    private var mainVM: MainVM?
    
    init(with window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storyboardId = NSStringFromClass(MainVC.self).components(separatedBy: ".").last!
        mainVM = MainVM()
        let mainVC = storyboard.instantiateViewController(withIdentifier: storyboardId) as! MainVC
        mainVC.inject(viewModel: mainVM!)
        mainVC.delegate = self
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    func startEditCountryGDP(countryGDPVM: CountryGDPVM) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storyboardId = NSStringFromClass(EditCountryGDPVC.self).components(separatedBy: ".").last!
        let editCountryGDPVC = storyboard.instantiateViewController(withIdentifier: storyboardId) as! EditCountryGDPVC
        editCountryGDPVC.delegate = self
        editCountryGDPVC.inject(viewModel: EditCountryGDPVM(countryGDPVM: countryGDPVM))
        navigationController.pushViewController(editCountryGDPVC, animated: true)
    }
}

extension AppCoord: MainVCDelegate {
    func requestToEditCountryGDP(countryGDPVM: CountryGDPVM) {
        startEditCountryGDP(countryGDPVM: countryGDPVM)
    }
}

extension AppCoord: EditCountryGDPVCDelegate {
    func didCountryGDPUpdate() {
        navigationController.popViewController(animated: true)
        mainVM?.updateDisplayResults()
    }
}
