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
    
    init(with window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storyboardId = NSStringFromClass(MainVC.self).components(separatedBy: ".").last!
        let mainVC = storyboard.instantiateViewController(withIdentifier: storyboardId) as! MainVC
        mainVC.inject(viewModel: MainVM())
        navigationController.pushViewController(mainVC, animated: false)
    }
}
