//
//  PlayerTableViewCell.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
