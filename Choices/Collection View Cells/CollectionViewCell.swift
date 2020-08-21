//
//  CollectionViewCell.swift
//  Choices
//
//  Created by Shubhra Mishra on 8/13/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dictionaryImage: UIImageView!
    
    @IBOutlet var dictionaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(image: UIImage) {
        dictionaryImage.image = image
    }
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    static let identifier = "CollectionViewCell"
}
