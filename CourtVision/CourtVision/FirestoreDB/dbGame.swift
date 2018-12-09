//
//  dbGame.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/3/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase
import MapKit


public class GameDM {
  var gameObj: [String : Any]
  
  //Constructor for new game creation
  init( _ homeTeamID: String, _ courtName: String, _ gameType: String, _ gameDatetime: String, _ gameLocationCds: MKPlacemark, _ locationName: String) {
    self.gameObj = [
      "courtInfo": [
        "image": "imageURLfromGoogleMaps",
        "courtName": courtName,
      ],
      "score": [
        "guestWin": false,
        "homeWin": false,
      ],
      "teams": [homeTeamID, ""], //Home team = index 0; Guest team = index 1
      "playersInvolved": [],
      "gameID": "", //Will be updated when in newGame function when inserting to Firestore db
      "gameType": gameType,
      "datetime": gameDatetime,
      "status": gamesListing,
      "location": [
        "lat": gameLocationCds.coordinate.latitude,
        "long": gameLocationCds.coordinate.longitude,
        "name": locationName
      ]
    ]
  }
  
  //Constructor for reading in game from Firestore
  init(_ data: ([String : Any])) {
    self.gameObj = data
  }
  
  //Initializes a new game in Firestore
  func newGame() {
    let db = getFirestoreDB()
    
    var ref: DocumentReference? = nil
    ref = db.collection(gamesCollection).addDocument(data: self.gameObj) {err in
      if let err = err {
        print(err.localizedDescription)
      }
      db.collection(gamesCollection).document(ref!.documentID).updateData([
        "gameID": ref!.documentID
      ]) {err in
        if let err = err {
          print(err.localizedDescription)
        }
      }
      getTeamMembersIDs() {(teamMembersIDs) in
        db.collection(gamesCollection).document(ref!.documentID).updateData([
          "playersInvolved": FieldValue.arrayUnion(teamMembersIDs)
        ])
      }
    }
  }
}


//Public functions relating to Game

//Get all current game listings
public func getGamesListings(completion: @escaping([GameDM]) -> ()) {
  let db = getFirestoreDB()
  let gamesRef = db.collection(gamesCollection)
  
  let games = gamesRef
    .whereField("status", isEqualTo: gamesListing)
  
  var gamesListings: [GameDM] = []
  
  games.getDocuments() {(query, err) in
    if let err = err {
      print("Error: \(err)")
    } else {
      for document in query!.documents {
        gamesListings.append(GameDM(document.data()))
      }
      completion(gamesListings)
    }
  }
}

//Returns games history
//Supported Game History Lists for:
//  - By team   ("teamID")
//  - By player ("playerID")
public func getGamesHistory(_ queryFieldName: String, _ queryFieldValue: String, completion: @escaping([GameDM]) -> ()) {
  let db = getFirestoreDB()
  let gamesRef = db.collection(gamesCollection)
  
  var allGames: [GameDM] = []
  
  let games = gamesRef
    .whereField(queryFieldName, arrayContains: queryFieldValue)
    .whereField("status", isEqualTo: gamesCompleted)
  
  games.getDocuments() {(query, err) in
    if let err = err {
      print("Error: \(err)")
    } else {
      for document in query!.documents {
        allGames.append(GameDM(document.data()))
      }
      completion(allGames)
    }
  }
}

//Returns proper game result based on index location of team in game object
public func getGameTeamResult(_ game: GameDM, _ teamID: String) -> String {
  let gameObj = game.gameObj
  let teams = gameObj[teamsField]! as! [String]
  let score = gameObj[scoreField]! as! [String : Any]
  if (teams[0] == teamID) {
    if (score[homeWinField]! as! Bool == true) {
      return "Win"
    }
    return "Loss"
  } else {
    if (score[guestWinField]! as! Bool == true) {
      return "Win"
    }
    return "Loss"
  }
}
