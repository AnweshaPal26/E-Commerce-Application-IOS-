//
//  MyOrdersTblCell.swift
//  Frashly
//
//

import UIKit

class MyOrdersTblCell: UITableViewCell {
    
    @IBOutlet weak var lbl_orderid: UILabel!
    
    @IBOutlet weak var lbl_orderDate: UILabel!
    
    @IBOutlet weak var lbl_status: UILabel!
    
    
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
