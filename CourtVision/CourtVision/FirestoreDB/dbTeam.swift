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
  init(_ managerID: String, _ teamName: String) {
    self.teamObj = [
      "managerID": managerID,
      "teamID": "",
      "teamName": teamName,
      "teamMembers": [managerID],
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
      }
    }
    db.collection(teamsCollection).document(ref!.documentID).updateData([
      teamIDField: ref!.documentID
    ]) {err in
      if let err = err {
        print(err.localizedDescription)
      }
    }
    ud.set(ref!.documentID, forKey: udTeamID)
    self.updateCreatorTeamID()
  }
  
  //Updates Creator's teamID
  private func updateCreatorTeamID() {
    let db = getFirestoreDB()
    let teamID = ud.string(forKey: udUserID)!
    db.collection(playersCollection).document(teamID).updateData([teamIDField: ud.string(forKey: udTeamID)!])
  }
}


//Public functions relating to Team

//Stores user's team id into UserDefaults
public func storeTeamIDUserDefaults() {
  getPlayerProfile(ud.string(forKey: udUserID)!) {(player) in
    if (player != nil) {
      let teamID = player?.playerObj[teamIDField]!
      ud.set(teamID, forKey: udTeamID)
    }
  }
}

//Returns all teams for in order of rank based on W/L record
public func getTeamRankings(completion: @escaping([TeamDM]) -> ()) {
  let db = getFirestoreDB()
  let teamRef = db.collection(teamsCollection)
  
  var allTeams: [TeamDM] = []
  
  teamRef.getDocuments() {(query, err) in
    if let err = err {
      print("Error: \(err)")
    } else {
      for document in query!.documents {
        allTeams.append(TeamDM(document.data()))
      }
      completion(allTeams)
    }
  }
}

//Returns player's team
public func getTeam(completion: @escaping(TeamDM?) -> ()) {
  let teamID = ud.string(forKey: udTeamID)!

  var resultTeam: TeamDM? = nil
  
  let db = getFirestoreDB()
  let teamRef = db.collection(teamsCollection).document(teamID)
  
  teamRef.getDocument {(document, error) in
    if let team = document.flatMap({
      $0.data().flatMap({ (data) in
        return TeamDM(data)
      })
    }) {
      resultTeam = team
    } else {
      print("Team does not exist")
    }
    completion(resultTeam)
  }
}

//Returns an array of all members on a team
func getTeamMembers(completion: @escaping([PlayerDM]) -> ()) {
  let teamID = ud.string(forKey: udTeamID)!
  
  let db = getFirestoreDB()
  let playersRef = db.collection(playersCollection)
  
  var teamPlayers: [PlayerDM] = []
  
  let players = playersRef
    .whereField(teamIDField, isEqualTo: teamID)
  
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

//Returns an array of all team members' ids
func getTeamMembersIDs(completion: @escaping([String]) -> ()) {
  let teamID = ud.string(forKey: udTeamID)!
  
  let db = getFirestoreDB()
  let teamRef = db.collection(teamsCollection).document(teamID)
  
  teamRef.getDocument {(document, error) in
    if let player = document.flatMap({
      $0.data().flatMap({ (data) in
        return PlayerDM(data)
      })
    }) {
      completion(player.playerObj[teamMembersField]! as! [String])
    } else {
      print("Document does not exist")
    }
  }
}

//Add a player to team
func addTeamMember(_ vc: UIViewController, _ addCode: String, completion: @escaping([PlayerDM]) -> ()) {
  let currUserID = ud.string(forKey: udUserID)!
  getTeam() {(team) in
    //Check if user is manager of team
    let managerID = team?.teamObj[teamManagerIDField]! as! String
    if (managerID == currUserID) {
      let db = getFirestoreDB()
      
      let playersRef = db.collection(playersCollection)
      let query = playersRef
        .whereField(addCodeField, isEqualTo: addCode)
      
      var player: PlayerDM?
      query.getDocuments() {(query, err) in
        if let err = err {
          print("Error: \(err)")
        }
        if (!query!.documents.isEmpty) {
          player = PlayerDM(query!.documents[0].data())
          if (player?.playerObj[teamIDField]! as? String == "") {
            let playerToAddID = player?.playerObj[playerIDField]! as! String
            
            let playerToAddRef = db.collection(playersCollection).document(playerToAddID)
            playerToAddRef.updateData([
              teamIDField: team?.teamObj[teamIDField]! as! String
              ])
            
            let teamRef = db.collection(teamsCollection).document(ud.string(forKey: udTeamID)!)
            teamRef.updateData([
              teamMembersField: FieldValue.arrayUnion([playerToAddID])
            ])
            getTeamMembers() {(playersArray) in
              completion(playersArray)
            }
          } else {
            teamErrorAlert(vc, "Error Adding Player", "This player is already a part of a team.")
          }
        } else {
          teamErrorAlert(vc, "Error Adding Player", "Invalid Add Code: Player does not exist.")
        }
      }
    } else {
      teamErrorAlert(vc, "Error Adding Player", "You are not authorized to add a team member.")
    }
  }
}

//Deletes a team member
func deleteTeamMember(_ vc: UIViewController, _ playerToDeleteID: String, completion: @escaping([PlayerDM]) -> ()) {
  let currUserID = ud.string(forKey: udUserID)!
  getTeam() {(team) in
    //Check if user is manager of team
    let managerID = team?.teamObj[teamManagerIDField]! as! String
    if (managerID == currUserID) {
      //Check if player being attempted to delete is not team manager
      if (managerID != playerToDeleteID) {
        let db = getFirestoreDB()
        
        //Replace user's teamID with empty string
        let playerRef = db.collection(playersCollection).document(playerToDeleteID)
        playerRef.updateData([teamIDField: ""])
        
        //Delete user's id from team's teamMembers array
        let teamRef = db.collection(teamsCollection).document(ud.string(forKey: udTeamID)!)
        teamRef.updateData([
          teamMembersField: FieldValue.arrayRemove([playerToDeleteID])
        ])
      } else {
        teamErrorAlert(vc, "Error Removing Player", "You must assign a new manager before removing yourself from the team.")
      }
    } else {
      teamErrorAlert(vc, "Error Removing Player", "You are not authorized to remove a team member.")
    }
    getTeamMembers() {(playersArray) in
      completion(playersArray)
    }
  }
}

public func teamErrorAlert(_ vc: UIViewController, _ title: String, _ errMsg: String) {
  let alert = UIAlertController(title: title, message: errMsg, preferredStyle: .alert)
  alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
  vc.present(alert, animated: true)
}
