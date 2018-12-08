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
    @IBOutlet weak var btnDeleteGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // still renders initially
        navBackBtn.setHidesBackButton(true, animated: true)

        btnDeleteGame.layer.cornerRadius = 3
        btnDeleteGame.layer.borderWidth = 1
        btnDeleteGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    }
    
}
