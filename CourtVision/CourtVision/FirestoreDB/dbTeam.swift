//
//  dbTeam.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/3/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase


public class TeamDM {
  var teamObj: [String : Any]
  var creatorID: String
  var teamName: String
  
  init(_ creatorID: String, _ teamName: String) {
    self.teamObj = [
      "creatorID": creatorID,
      "teamID": "",
      "teamName": teamName,
      "teamMembers": [],
      "activeGame": "",
      "gamesHistory": [],
      "record": [
        "totalGames": 0,
        "wins": 0,
        "losses": 0
      ]
    ]
    
    self.creatorID = creatorID
    self.teamName = teamName
  }
  
  //Creates a new team object and inserts into Firestore db
  func newTeam() {
    var db: Firestore!
    Firestore.firestore().settings = FirestoreSettings()
    db = Firestore.firestore()
    
    var ref: DocumentReference? = nil
    ref = db.collection(FirebaseConstants.shared.teamsCollection).addDocument(data: self.teamObj) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error. " + err.localizedDescription)
      }
    }
    db.collection(FirebaseConstants.shared.teamsCollection).document(ref!.documentID).updateData([
      "teamID": ref!.documentID
    ]) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error 2. " + err.localizedDescription)
      }
    }
  }
}
