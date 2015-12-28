
//
//  MsgGroupContentCell.swift
//  waterbbs
//
//  Created by y on 15/12/28.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MsgGroupContentCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
