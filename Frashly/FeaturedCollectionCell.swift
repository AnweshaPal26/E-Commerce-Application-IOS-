//
//  FeaturedCollectionCell.swift
//  Frashly
//
//

import UIKit

class FeaturedCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img_featuredcell: UIImageView!
    
    @IBOutlet weak var lbl_featuredcellName: UILabel!
    
    @IBOutlet weak var lbl_featuredcellPrice: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_featuredcell.image = UIImage(named: "default")
    }
}
