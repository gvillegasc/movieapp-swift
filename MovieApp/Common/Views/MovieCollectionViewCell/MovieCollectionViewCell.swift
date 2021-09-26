//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 17/09/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 15
        movieImageView.clipsToBounds = true
    }
}
