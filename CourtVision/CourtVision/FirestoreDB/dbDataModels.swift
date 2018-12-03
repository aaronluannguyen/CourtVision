//
//  dbDataModels.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation

//Player Data Model
public class PlayerDM {
  var playerObj: [String : Any]
  
  init(_ email: String, _ addCode: String) {
    self.playerObj = [
      "profile": [
        "email": email,
        "firstName": "",
        "lastName": "",
        "height": "",
        "weightPounds": 0
      ],
      "teamID": "",
      "addCode": addCode
    ]
  }
}


//Team Data Model
public class TeamDM {
  var teamObj: [String : Any]
  
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
  }
}



//Game Data Model
public class GameDM {
  var gameObj: [String : Any]
  
  init(_ gameType: String) {
    self.gameObj = [
      "something": "something",
      "gameType": gameType
    ]
  }
}
