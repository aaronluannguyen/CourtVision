//
//  NoGameViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class NoGameViewController: UIViewController {

    @IBOutlet weak var navBackBtn: UINavigationItem!
    @IBOutlet weak var btnCreateGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // still renders initially
        navBackBtn.setHidesBackButton(true, animated: true)

        btnCreateGame.layer.cornerRadius = 3
        btnCreateGame.layer.borderWidth = 1
        btnCreateGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    }
    
    @IBAction func onCreateGameClick(_ sender: Any) {
//        self.performSegue(withIdentifier: "FromNoGameToCreate", sender: sender)
    }

}
