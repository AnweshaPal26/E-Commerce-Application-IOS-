//
//  CategoryHorizonCollectionVC.swift
//  Frashly
//
//

import UIKit

class CategoryHorizonCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var img_category: UIImageView!
    
    @IBOutlet weak var lbl_category: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_category.image = UIImage(named: "default")
    }
}
