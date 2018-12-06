//
//  dbPlayer.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/3/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase


public class PlayerDM {
  var playerObj: [String : Any]
  
  //Constructor for new player creation
  init(_ userID: String, _ email: String, _ addCode: String) {
    self.playerObj = [
      "profile": [
        "email": email,
        "firstName": "",
        "lastName": "",
        "height": "",
        "weightPounds": 0,
        "position": "N/A",
        "totalGames": 0,
        "totalWins": 0,
        "totalLosses": 0,
      ],
      "teamID": "",
      "addCode": addCode
    ]
  }
  
  //Constructor for reading in player from Firestore
  init(_ data: ([String : Any])) {
    self.playerObj = data
  }

  
  //Initializes new player into Firestore db
  func newPlayer() {
    let db = getFirestoreDB()
    
    db.collection(playersCollection).document(ud.string(forKey: udUserID)!).setData(self.playerObj) {err in
      if let err = err {
        print(err.localizedDescription)
        //self.signupErrorAlert("Firebase Error", "Player insertion into database error. " + err.localizedDescription)
      }
    }
  }
}


//Public functions relating to Player

//Returns player's profile
public func getPlayerProfile(_ playerID: String, completion: @escaping (PlayerDM?) -> Void) {
  let db = getFirestoreDB()
  
  var resultPlayer: PlayerDM? = nil
  
  let docRef = db.collection(playersCollection).document(playerID)
  
  docRef.getDocument {(document, error) in
    if let player = document.flatMap({
      $0.data().flatMap({ (data) in
        return PlayerDM(data)
      })
    }) {
      resultPlayer = player
    } else {
      print("Document does not exist")
    }
    completion(resultPlayer)
  }
}
