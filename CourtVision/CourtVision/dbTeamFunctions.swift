//
//  dbTeamFunctions.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase

public func newTeam(_ teamName: String) {
  var db: Firestore!
  Firestore.firestore().settings = FirestoreSettings()
  db = Firestore.firestore()
  
  let team = TeamDM(teamName)
  var ref: DocumentReference? = nil
  ref = db.collection(FirebaseConstants.shared.teamsCollection).addDocument(data: team.teamObj) {err in
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
