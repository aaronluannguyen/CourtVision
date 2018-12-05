//
//  SignUpViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/1/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
  
  //ud -> Short for UserDefault
  let udUserEmail = "userEmail"
  
  
  //ViewController References
  @IBOutlet weak var imgBG: UIImageView!
  @IBOutlet weak var imgLogo: UIImageView!
  @IBOutlet weak var btnSignUp: UIButton!
  
  @IBOutlet weak var tfEmail: UITextField!
  @IBAction func tfEmailOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  @IBOutlet weak var tfPassword: UITextField!
  @IBAction func tfPasswordOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  @IBOutlet weak var tfPasswordConf: UITextField!
  @IBAction func tfPasswordConfOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  
  //Segues
  let segueFromSignupToLogin = "FromSignupToLogin"
  let segueFromSignupToBrowse = "FromSignupToBrowse"
  
  
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
    btnSignUp.isEnabled = false
    
    tfPassword.isSecureTextEntry = true
    tfPasswordConf.isSecureTextEntry = true
  }
  
  
  @IBAction func onLoginClick(_ sender: Any) {
      self.performSegue(withIdentifier: "FromSignupToLogin", sender: sender)
  }
  
  @IBAction func onSignupClick(_ sender: Any) {
    firebaseSignup(
      tfEmail.text!,
      tfPassword.text!,
      tfPasswordConf.text!
    )
  }
  
  //Helper Functions
  func updateBtnSignupEnabled() {
    if (
      self.tfEmail.text!.count > 0
        && self.tfPassword.text!.count > 0
        && self.tfPasswordConf.text!.count > 0
      ) {
      self.btnSignUp.isEnabled = true
    } else {
      self.btnSignUp.isEnabled = false
    }
  }
  
  func firebaseSignup(_ email: String, _ password: String, _ passwordConfirmation: String) {
    if (checkPasswordMatch(password, passwordConfirmation)) {
      Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
        guard let user = authResult?.user else {
          self.signupErrorAlert("Signup Error", error!.localizedDescription)
          return
        }
        UserDefaults.standard.set(user.uid, forKey: udUserID)
        
        //Insert initialized player into DB under Players
        let player = PlayerDM(user.uid, user.email!, "SF", self.getPlayerAddCode())
        player.newPlayer()
        
        //Perform segue to main screen
        self.performSegue(withIdentifier: self.segueFromSignupToBrowse, sender: self)
      }
    }
  }
  
  func checkPasswordMatch(_ password: String, _ passwordConfirmation: String) -> Bool {
    if (password != passwordConfirmation) {
      return false
    }
    return true
  }
  
  func signupErrorAlert(_ title: String, _ errMessage: String) {
    let alert = UIAlertController(title: title, message: errMessage, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func getPlayerAddCode() -> String {
    let digits = 0...9
    let shuffleDigits = digits.shuffled()
    let fourDigits = shuffleDigits.prefix(4)
    
    let result = fourDigits.reduce(0) {
      $0*10 + $1
    }
    
    var stringResult = String(result)
    if (stringResult.count <= 3) {
      stringResult = "0" + stringResult
    }
    
    return stringResult
  }
}
