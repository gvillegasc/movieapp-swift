//
//  UIViewControllerExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 21/09/21.
//

import UIKit

extension UIViewController {
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
