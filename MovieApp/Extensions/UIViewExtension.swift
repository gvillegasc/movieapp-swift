//
//  UIViewExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import UIKit
import Foundation

extension UIView {
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
