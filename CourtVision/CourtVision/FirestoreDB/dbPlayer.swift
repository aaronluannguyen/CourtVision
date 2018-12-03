//
//  dbPlayerFunctions.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase


public class PlayerDM {
  var playerObj: [String : Any]
  var userID: String
  
  init(_ userID: String, _ email: String, _ position: String, _ addCode: String) {
    self.playerObj = [
      "profile": [
        "email": email,
        "firstName": "",
        "lastName": "",
        "height": "",
        "weightPounds": 0,
        "position": position
      ],
      "teamID": "",
      "addCode": addCode
    ]
    
    self.userID = userID
  }
  
  //Initializes new player into Firestore db
  func newPlayer() {
    var db: Firestore!
    Firestore.firestore().settings = FirestoreSettings()
    db = Firestore.firestore()
    
    db.collection(FirebaseConstants.shared.playersCollection).document(self.userID).setData(self.playerObj) {err in
      if let err = err {
        print(err.localizedDescription)
        //      self.signupErrorAlert("Firebase Error", "Player insertion into database error. " + err.localizedDescription)
      }
    }
  }
}
