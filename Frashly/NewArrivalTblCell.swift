//
//  NewArrivalTblCell.swift
//  Frashly
//
//

import UIKit

class NewArrivalTblCell: UITableViewCell {
    
    @IBOutlet weak var img_new: UIImageView!
    
    @IBOutlet weak var lbl_newName: UILabel!
    
    @IBOutlet weak var lbl_newPrice: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_new.image = UIImage(named: "default")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
