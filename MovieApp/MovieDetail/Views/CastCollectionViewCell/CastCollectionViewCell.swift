//
//  CastCollectionViewCell.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 21/09/21.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorCharacter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actorImage.layer.borderWidth = 1
        actorImage.layer.masksToBounds = false
        actorImage.layer.borderColor = UIColor.black.cgColor
        actorImage.layer.cornerRadius = actorImage.frame.height / 2
        actorImage.clipsToBounds = true
    }

}
