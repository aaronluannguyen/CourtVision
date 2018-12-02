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
  
  init(_ email: String) {
    self.playerObj = [
      "profile": [
        "email": email,
        "firstName": "",
        "lastName": "",
        "height": "",
        "weightPounds": 0
      ],
      "teamID": "",
    ]
  }
}


//Team Data Model
public class TeamDM {
  var teamObj: [String : Any]
  
  init(_ teamName: String) {
    self.teamObj = [
      "teamID": "",
      "teamName": teamName,
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
  
  init() {
    self.gameObj = [
      "something": "something"
    ]
  }
}
