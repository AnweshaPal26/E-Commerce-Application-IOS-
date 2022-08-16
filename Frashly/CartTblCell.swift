//
//  CartTblCell.swift
//  Frashly
//
//

import UIKit

class CartTblCell: UITableViewCell {
    
    @IBOutlet weak var img_cart: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var lbl_qty: UILabel!
    
    @IBOutlet weak var cart_delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
