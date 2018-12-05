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

public let teamsCollection = "teams"

public let gamesCollection = "games"
public let gamesListing = "listings"
public let gamesActive = "active"
public let gamesCompleted = "completed"


//Functions

public func getFirestoreDB() -> Firestore {
  var db: Firestore!
  Firestore.firestore().settings = FirestoreSettings()
  db = Firestore.firestore()
  return db
}
