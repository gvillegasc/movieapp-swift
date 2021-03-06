//
//  UIImageExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func imageFromMovieDB(urlString: String, placeHolderImage: UIImage, highResolution: Bool = false) {
        let url = URL(string:(highResolution ? "\(Constants.URL.urlImagesMovieDB)/w500" : "\(Constants.URL.urlImagesMovieDB)/w200") + urlString)
        self.sd_setImage(with: url, placeholderImage: placeHolderImage) { [weak self] (image, error, type, url) in
            if let image = image {
                self!.image = image
            } else {
                self!.image = placeHolderImage
            }
        }
    }
}
 
