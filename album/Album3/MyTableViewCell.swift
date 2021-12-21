//
//  MyTableViewCell.swift
//  Album3
//
//  Created by mac on 2021/12/21.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var classLabel = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
