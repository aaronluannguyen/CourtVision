//
//  NoTeamViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class NoTeamViewController: UIViewController {

    @IBOutlet weak var navBackBtn: UINavigationItem!
    @IBOutlet weak var labelAddCode: UILabel!
    @IBOutlet weak var btnCreateTeam: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // still renders initially
        navBackBtn.setHidesBackButton(true, animated: true)

        btnCreateTeam.layer.cornerRadius = 3
        btnCreateTeam.layer.borderWidth = 1
        btnCreateTeam.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    }

}
