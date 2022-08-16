//
//  NewArrivalCollectionCell.swift
//  Frashly
//
//

import UIKit

class NewArrivalCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img_newArrival: UIImageView!
    
    @IBOutlet weak var lbl_newArrivalName: UILabel!
    
    @IBOutlet weak var lbl_newArrivalPrice: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_newArrival.image = UIImage(named: "default")
    }
    
}
