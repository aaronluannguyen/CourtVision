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
  init( _ homeTeamID: String, _ courtName: String, _ gameType: String, _ gameDate: String, _ gameTime: String, _ gameAddress: String) {
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
      "guestTeam": "", //Will be updated when guest team joins game
      "homeTeam": homeTeamID,
      "gameID": "", //Will be updated when in newGame function when inserting to Firestore db
      "gameType": gameType,
      "date": gameDate,
      "time": gameTime,
      "status": gamesListing
    ]
  }
  
  //Constructor for reading in game from Firestore
  init(_ data: [String : Any], _ userID: String) {
    self.gameObj = data
  }
  
  //Initializes a new game in Firestore
  func newGame() {
    let db = getFirestoreDB()
    
    var ref: DocumentReference? = nil
    ref = db.collection(gamesCollection).addDocument(data: self.gameObj) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error. " + err.localizedDescription)
      }
    }
    db.collection(gamesCollection).document(ref!.documentID).updateData([
      "gameID": ref!.documentID
    ]) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error 2. " + err.localizedDescription)
      }
    }
  }
}


//Public functions relating to Game

public func getGamesHistoryFromTeam(_ teamID: String) {
  let db = getFirestoreDB()
  let gamesRef = db.collection(gamesCollection)
  
  let games = gamesRef.whereField("homeTeam", isEqualTo: teamID).getDocuments(completion:
    {(query, err) in
      if let err = err {
        print("\(err)")
      } else {
        for doc in query!.documents {
          print("\(doc.documentID)")
        }
      }
    }
  )
  
  print("LOLOLOLOL")
  print(games)
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
