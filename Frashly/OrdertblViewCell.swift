//
//  OrdertblViewCell.swift
//  Frashly
//
//

import UIKit

class OrdertblViewCell: UITableViewCell {
    
    @IBOutlet weak var img_order: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var lbl_qty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
