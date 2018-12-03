//
//  ViewController.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 11/24/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    imgBG.image = #imageLiteral(resourceName: "background")
    imgLogo.image = #imageLiteral(resourceName: "logo")
    btnLogin.setTitle("Login", for: .normal)
    btnLogin.backgroundColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0)
    btnLogin.layer.cornerRadius = 3
    btnLogin.layer.borderWidth = 1
    btnLogin.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0).cgColor
    btnSignUp.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0), for: .normal)
  }
    
    @IBAction func onSignUpClick(_ sender: Any) {
        self.performSegue(withIdentifier: "FromLoginToSignup", sender: sender)
    }
    
}
