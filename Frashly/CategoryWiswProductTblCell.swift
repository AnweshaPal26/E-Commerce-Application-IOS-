//
//  CategoryWiswProductTblCell.swift
//  Frashly
//
//

import UIKit

class CategoryWiswProductTblCell: UITableViewCell {
    
    
    @IBOutlet weak var img_product: UIImageView!
    
    @IBOutlet weak var lbl_productName: UILabel!
    
    @IBOutlet weak var lbl_productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
