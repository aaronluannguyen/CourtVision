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
      "teamMembers": [creatorID],
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
    let db = getFirestoreDB()
    
    var ref: DocumentReference? = nil
    ref = db.collection(teamsCollection).addDocument(data: self.teamObj) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error. " + err.localizedDescription)
      }
    }
    db.collection(teamsCollection).document(ref!.documentID).updateData([
      "teamID": ref!.documentID
    ]) {err in
      if let err = err {
        print(err.localizedDescription)
        //signupErrorAlert("Firebase Error", "Team insertion into database error 2. " + err.localizedDescription)
      }
    }
  }
}


//Public functions relating to Team
public func storeTeamIDUserDefaults() {
  getPlayerProfile(ud.string(forKey: udUserID)!) {(player) in
    if (player != nil) {
      let teamID = player?.playerObj["teamID"]!
      ud.set(teamID, forKey: udTeamID)
      print(ud.string(forKey: udTeamID)! as String)
    }
  }
}
