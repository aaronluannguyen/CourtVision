//
//  ListingViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {

    @IBOutlet weak var navBackBtn: UINavigationItem!
    @IBOutlet weak var btnMatch: UIButton!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var txtTeam: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var btnDeleteGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // still renders initially
        navBackBtn.setHidesBackButton(true, animated: true)
        btnMatch.isEnabled = false
        btnMatch.layer.cornerRadius = 14
        btnMatch.layer.borderWidth = 1
        btnMatch.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor

        btnDeleteGame.layer.cornerRadius = 3
        btnDeleteGame.layer.borderWidth = 1
        btnDeleteGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    }
    
}
