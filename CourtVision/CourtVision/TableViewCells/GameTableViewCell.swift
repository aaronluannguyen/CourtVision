//
//  GameTableViewCell.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var btnResult: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
