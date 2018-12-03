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
  
  //Constants

  //ud -> Short for UserDefault
  let udUserEmail = "userEmail"

  
  //ViewController References
  @IBOutlet weak var imgBG: UIImageView!
  @IBOutlet weak var imgLogo: UIImageView!
  @IBOutlet weak var btnSignUp: UIButton!
  @IBOutlet weak var textfieldEmail: UITextField!
  @IBAction func textfieldEmailOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  @IBOutlet weak var textfieldPassword: UITextField!
  @IBAction func textfieldPasswordOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  @IBOutlet weak var textfieldPasswordConfirmation: UITextField!
  @IBAction func textfieldPasswordConfirmationOnChange(_ sender: Any) {
    updateBtnSignupEnabled()
  }
  
  
  //Segues
  let segueFromSignupToLogin = "FromSignupToLogin"
  
  //Firebase Init
  var db: Firestore!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    Firestore.firestore().settings = FirestoreSettings()
    db = Firestore.firestore()
    
    imgBG.image = #imageLiteral(resourceName: "background")
    imgLogo.image = #imageLiteral(resourceName: "logo")
    
    btnSignUp.setTitle("Sign Up", for: .normal)
    btnSignUp.backgroundColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0)
    btnSignUp.layer.cornerRadius = 3
    btnSignUp.layer.borderWidth = 1
    btnSignUp.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1.0).cgColor
    btnSignUp.isEnabled = false
    
    textfieldPassword.isSecureTextEntry = true
    textfieldPasswordConfirmation.isSecureTextEntry = true
  }
  
  @IBAction func onLoginClick(_ sender: Any) {
    self.performSegue(withIdentifier: self.segueFromSignupToLogin, sender: sender)
  }
  
  
  @IBAction func onSignupClick(_ sender: Any) {
    firebaseSignup(
      textfieldEmail.text!,
      textfieldPassword.text!,
      textfieldPasswordConfirmation.text!
    )
  }
  
  
  //Helper Functions
  
  func updateBtnSignupEnabled() {
    if (
      self.textfieldEmail.text!.count > 0
      && self.textfieldPassword.text!.count > 0
      && self.textfieldPasswordConfirmation.text!.count > 0
    ) {
      self.btnSignUp.isEnabled = true
    } else {
      self.btnSignUp.isEnabled = false
    }
  }
  
  func checkPasswordMatch(_ password: String, _ passwordConfirmation: String) -> Bool {
    if (password != passwordConfirmation) {
      return false
    }
    
    return true
  }
  
  func firebaseSignup(_ email: String, _ password: String, _ passwordConfirmation: String) {
    if (checkPasswordMatch(password, passwordConfirmation)) {
      Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
        guard let user = authResult?.user else {
          self.signupErrorAlert("Signup Error", error!.localizedDescription)
          return
        }
        UserDefaults.standard.set(user.uid, forKey: UserDefaultConstants.shared.udUserID)
        
        //Insert initialized player into DB under Players
        let newPlayer = PlayerDM(user.email!, self.getPlayerAddCode())
        
        self.db.collection(FirebaseConstants.shared.playersCollection).document(user.uid).setData(newPlayer.playerObj) {err in
          if let err = err {
            self.signupErrorAlert("Firebase Error", "Player insertion into database error. " + err.localizedDescription)
          }
        }
        
        //Perform segue to main screen
      }
    }
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
