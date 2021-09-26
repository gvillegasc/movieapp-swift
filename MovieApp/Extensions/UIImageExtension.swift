//
//  UIImageExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 19/09/21.
//

import UIKit

extension UIImageView {
    
    func imageFromUrl(urlString: String, placeHolderImage: UIImage) {
        if self.image == nil {
            self.image = placeHolderImage
        }
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil { return }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
    
    func imageFromMovieDB(urlString: String, placeHolderImage: UIImage, highResolution: Bool = false) {
        if self.image == nil {
            self.image = placeHolderImage
        }
        let url = URL(string:(highResolution ? "\(Constants.URL.urlImagesMovieDB)/w500" : "\(Constants.URL.urlImagesMovieDB)/w200") + urlString)

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil { return }

            DispatchQueue.main.async {
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}
