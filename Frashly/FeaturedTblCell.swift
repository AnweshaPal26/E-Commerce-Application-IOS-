//
//  FeaturedTblCell.swift
//  Frashly
//
//

import UIKit

class FeaturedTblCell: UITableViewCell {
    
    
    @IBOutlet weak var featured_img: UIImageView!
    
    @IBOutlet weak var featured_lblName: UILabel!
    
    @IBOutlet weak var featured_lblPrice: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featured_img.image = UIImage(named: "default")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
