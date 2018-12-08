//
//  PlayViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "FromActiveToLive", sender: self)
//        self.performSegue(withIdentifier: "FromActiveToCreate", sender: self)
//        self.performSegue(withIdentifier: "FromActiveToListing", sender: self)
    }

}
