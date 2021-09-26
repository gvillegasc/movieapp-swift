//
//  UIApplicationExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 22/09/21.
//

import UIKit

extension UIApplication {
    
    static var topSafeAreaHeight: CGFloat {
        var topSafeAreaHeight: CGFloat = 0
         if #available(iOS 11.0, *) {
               let window = UIApplication.shared.windows[0]
               let safeFrame = window.safeAreaLayoutGuide.layoutFrame
               topSafeAreaHeight = safeFrame.minY
             }
        return topSafeAreaHeight
    }
}
