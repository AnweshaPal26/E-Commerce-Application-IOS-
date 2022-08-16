//
//  NotificationCell.swift
//  Frashly
//
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var lbl_time: UILabel!
    
    @IBOutlet weak var lbl_orderid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
