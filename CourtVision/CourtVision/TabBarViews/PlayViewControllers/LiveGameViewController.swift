//
//  LiveGameViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class LiveGameViewController: UIViewController {

    @IBOutlet weak var navBackBtn: UINavigationItem!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var btnMatch: UIButton!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var txtTeam: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var btnWin: UIButton!
    @IBOutlet weak var btnLoss: UIButton!
    @IBOutlet weak var container: UIView!
    
    var hidden = false
    
//    override func viewWillAppear(_ animated: Bool) {
//        navBackBtn.setHidesBackButton(true, animated: true)
//    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      // still renders initially
      navBackBtn.setHidesBackButton(true, animated: true)
      
      btnMatch.isEnabled = false
      btnMatch.layer.cornerRadius = 14
      btnMatch.layer.borderWidth = 1
      btnMatch.layer.backgroundColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
      btnMatch.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
      
      container.isHidden = hidden
      if (!hidden) {
        btnWin.layer.cornerRadius = 10
        btnWin.layer.borderWidth = 1
        btnWin.layer.backgroundColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        btnWin.layer.borderColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        btnLoss.layer.cornerRadius = 10
        btnLoss.layer.borderWidth = 1
        btnLoss.layer.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        btnLoss.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
      }
    }
    
    @IBAction func onWinClick(_ sender: Any) {
        let alert = UIAlertController(title: "Congratulations!", message: "You are about to record a win for your team, is that correct?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        //increment win count for home team
    }
    
    @IBAction func onLossClick(_ sender: Any) {
        let alert = UIAlertController(title: "Nice Try", message: "You are about to record a loss for your team, is that correct?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        //increment loss count for home team
    }

}
