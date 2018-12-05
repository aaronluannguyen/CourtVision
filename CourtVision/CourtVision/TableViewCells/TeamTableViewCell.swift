//
//  TeamTableViewCell.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/5/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var txtRank: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtRecord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
