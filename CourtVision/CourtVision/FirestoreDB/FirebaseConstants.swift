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
public let playerIDField = "playerID"
public let profileField = "profile"
public let addCodeField = "addCode"
public let firstNameField = "firstName"
public let lastNameField = "lastName"
public let positionField = "position"
public let heightField = "height"
public let weightPoundsField = "weightPounds"
public let totalWinsField = "totalWins"
public let totalLossesField = "totalLosses"

public let teamsCollection = "teams"
public let teamIDField = "teamID"
public let teamManagerIDField = "managerID"
public let teamNameField = "teamName"
public let teamMembersField = "teamMembers"
public let recordField = "record"
public let winsField = "wins"
public let lossesField = "losses"
public let totalGamesField = "totalGames"

public let gamesCollection = "games"
public let gameIDField = "gameID"
public let gameTypeField = "gameType"
public let gameType3 = "3v3"
public let gameType5 = "5v5"
public let gamesListing = "listing"
public let gamesActive = "active"
public let gamesCompleted = "completed"
public let gamesDeleted = "deleted"
public let teamsField = "teams"
public let playersInvolvedField = "playersInvolved"
public let scoreField = "score"
public let homeWinField = "homeWin"
public let guestWinField = "guestWin"
public let courtNameField = "courtName"
public let courtInfoField = "courtInfo"
public let datetimeField = "datetime"
public let locationField = "location"
public let latField = "lat"
public let longField = "long"
public let nameField = "name"
public let addressField = "address"
public let statusField = "status"


//Functions

public func getFirestoreDB() -> Firestore {
  var db: Firestore!
  Firestore.firestore().settings = FirestoreSettings()
  db = Firestore.firestore()
  return db
}
