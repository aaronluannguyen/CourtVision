//
//  dbGame.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/3/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase


public class GameDM {
  var gameObj: [String : Any]
  
  //Constructor for new game creation
  init( _ homeTeamID: String, _ courtName: String, _ gameType: String, _ gameTime: String, _ gameAddress: String) {
    self.gameObj = [
      "courtInfo": [
        "image": "imageURLfromGoogleMaps",
        "courtName": courtName,
        "location": gameAddress
      ],
      "score": [
        "guestWin": false,
        "homeWin": false,
      ],
      "teams": [
        "guest": "",
        "home": homeTeamID
      ],
      "gameType": gameType,
      "time": gameTime,
      "status": "listing"
    ]
  }
  
  //Constructor for reading in game from Firestore
  init(_ data: [String : Any], _ userID: String) {
    self.gameObj = data
  }
  
  //Initializes a new game in Firestore
  func newGame() {
    
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
