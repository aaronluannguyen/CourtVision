//
//  FirebaseConstants.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase

public let playersCollection = "players"
public let addCodeField = "addCode"

public let teamsCollection = "teams"
public let teamIDField = "teamID"
public let teamMembersField = "teamMembers"

public let gamesCollection = "games"
public let gamesListing = "listings"
public let gamesActive = "active"
public let gamesCompleted = "completed"
public let teamsField = "teams"
public let playersInvolvedField = "playersInvolved"


//Functions

public func getFirestoreDB() -> Firestore {
  var db: Firestore!
  Firestore.firestore().settings = FirestoreSettings()
  db = Firestore.firestore()
  return db
}
