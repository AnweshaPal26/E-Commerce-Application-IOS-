//
//  WishlistTblCell.swift
//  Frashly
//
//

import UIKit

class WishlistTblCell: UITableViewCell {
    
    @IBOutlet weak var wish_img: UIImageView!
    
    @IBOutlet weak var wish_name: UILabel!
    
    @IBOutlet weak var wish_price: UILabel!
    
    @IBOutlet weak var wish_delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
