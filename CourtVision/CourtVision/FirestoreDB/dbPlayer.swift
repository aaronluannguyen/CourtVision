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

  
  //Constructor for new player creation
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
  
  //Constructor for reading in player from Firestore
  init(_ data: [String : Any], _ userID: String) {
    self.playerObj = data
    
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
        //self.signupErrorAlert("Firebase Error", "Player insertion into database error. " + err.localizedDescription)
      }
    }
  }
}

//example of querying for player and then accessing nested dictionaries.
//
//var db: Firestore!
//Firestore.firestore().settings = FirestoreSettings()
//db = Firestore.firestore()
//
//let docRef = db.collection("players").document("pRwp8j8TpofbTCfZqywEfwHPiuD3")
//
//docRef.getDocument { (document, error) in
//  if let city = document.flatMap({
//    $0.data().flatMap({ (data) in
//      return PlayerDM(data, "pRwp8j8TpofbTCfZqywEfwHPiuD3")
//    })
//  }) {
//    print("City: \(city)")
//    let profile = city.playerObj["profile"] as! [String:Any]
//    print(profile["email"])
//  } else {
//    print("Document does not exist")
//  }
//}
