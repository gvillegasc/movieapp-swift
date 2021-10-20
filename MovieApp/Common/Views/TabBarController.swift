//
//  TabBarController.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 4/10/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
         if selectedIndex == 1 {
             
         }
     }
}
