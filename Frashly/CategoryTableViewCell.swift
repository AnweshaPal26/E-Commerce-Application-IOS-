//
//  CategoryTableViewCell.swift
//  Frashly
//
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Category_img: UIImageView!
    
    @IBOutlet weak var category_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
