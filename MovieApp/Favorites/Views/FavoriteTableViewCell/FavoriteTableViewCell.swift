//
//  FavoriteTableViewCell.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 1/10/21.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var releaseDateMovieLabel: UILabel!
    
    // MARK: - Lifecycle Events
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
