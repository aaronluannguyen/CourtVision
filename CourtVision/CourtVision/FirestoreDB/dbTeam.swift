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
  
  //Constructor for new team creation
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
  }
  
  //Constructor for team data read in from Firestore
  init(_ data: ([String : Any])) {
    self.teamObj = data
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
    ud.set(ref!.documentID, forKey: udTeamID)
    self.updateCreatorTeamID()
  }
  
  //Updates Creator's teamID
  private func updateCreatorTeamID() {
    let db = getFirestoreDB()
    db.collection(playersCollection).document(ud.string(forKey: udUserID)!).updateData(["teamID": ud.string(forKey: udTeamID)!])
  }
  
  //
  func getTeamMembers(completion: @escaping([PlayerDM]) -> ()) {
    let teamID = self.teamObj["teamID"]! as! String
    
    let db = getFirestoreDB()
    let playersRef = db.collection(playersCollection)
    
    var teamPlayers: [PlayerDM] = []
    
    let players = playersRef
      .whereField("teamID", isEqualTo: teamID)
    
    players.getDocuments() {(query, err) in
      if let err = err {
        print("Error: \(err)")
      } else {
        for document in query!.documents {
          teamPlayers.append(PlayerDM(document.data()))
        }
        completion(teamPlayers)
      }
    }
  }
}


//Public functions relating to Team

//Stores user's team id into UserDefaults
public func storeTeamIDUserDefaults() {
  getPlayerProfile(ud.string(forKey: udUserID)!) {(player) in
    if (player != nil) {
      let teamID = player?.playerObj["teamID"]!
      ud.set(teamID, forKey: udTeamID)
    }
  }
}
