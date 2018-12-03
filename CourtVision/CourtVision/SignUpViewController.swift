//
//  SignUpViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/1/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgBG.image = #imageLiteral(resourceName: "background")
        imgLogo.image = #imageLiteral(resourceName: "logo")
        btnSignUp.setTitle("Sign Up", for: .normal)
        btnSignUp.backgroundColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0)
        btnSignUp.layer.cornerRadius = 3
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0).cgColor
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        self.performSegue(withIdentifier: "FromSignupToLogin", sender: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
