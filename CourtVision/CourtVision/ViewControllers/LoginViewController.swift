//
//  ViewController.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 11/24/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  //ViewController References
  @IBOutlet weak var imgBG: UIImageView!
  @IBOutlet weak var imgLogo: UIImageView!
  @IBOutlet weak var btnLogin: UIButton!
  @IBOutlet weak var btnSignUp: UIButton!
  
  @IBOutlet weak var tfEmail: UITextField!
  @IBAction func tfEmailOnChange(_ sender: Any) {
    updateBtnLoginEnabled()
  }
  
  
  @IBOutlet weak var tfPassword: UITextField!
  @IBAction func tfPasswordOnChange(_ sender: Any) {
    updateBtnLoginEnabled()
  }
  
  
  //Segues
  let segueFromLoginToSignup = "FromLoginToSignup"
  let segueFromLoginToBrowse = "FromLoginToBrowse"
    
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
    btnLogin.isEnabled = false
    
    btnSignUp.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0), for: .normal)
    
    tfPassword.isSecureTextEntry = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    firebaseCheckSession()
  }
  
  @IBAction func onSignUpClick(_ sender: Any) {
      self.performSegue(withIdentifier: segueFromLoginToSignup, sender: sender)
  }
  
  @IBAction func onLoginClick(_ sender: Any) {
    firebaseLogin(tfEmail.text!, tfPassword.text!)
  }
  
  
  //Helper Functions
  func updateBtnLoginEnabled() {
    if (
      self.tfEmail.text!.count > 0
        && self.tfPassword.text!.count > 0
      ) {
      self.btnLogin.isEnabled = true
    } else {
      self.btnLogin.isEnabled = false
    }
  }
  
  func firebaseCheckSession() {
    if (Auth.auth().currentUser != nil) {
      //Perform segue to browse screen
      self.performSegue(withIdentifier: self.segueFromLoginToBrowse, sender: self)
    }
  }
  
  func firebaseLogin(_ email: String, _ password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
      guard let user = authResult?.user else {
        self.loginErrorAlert("Login Error", error!.localizedDescription)
        return
      }
      UserDefaults.standard.set(user.uid, forKey: udUserID)
      
      //Perform segue to browse screen
      self.performSegue(withIdentifier: self.segueFromLoginToBrowse, sender: self)
    }
  }
  
  func loginErrorAlert(_ title: String, _ errMessage: String) {
    let alert = UIAlertController(title: title, message: errMessage, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
}
