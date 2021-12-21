//
//  PicTableViewCell.swift
//  Album3
//
//  Created by mac on 2021/12/22.
//

import UIKit

class PicTableViewCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    
    var img:UIImage = UIImage()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
