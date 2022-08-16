//
//  SearchTblCell.swift
//  Frashly
//
//

import UIKit

class SearchTblCell: UITableViewCell {
    
    @IBOutlet weak var img_search: UIImageView!
    
    @IBOutlet weak var lbl_searchName: UILabel!
    
    @IBOutlet weak var lbl_searchPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
