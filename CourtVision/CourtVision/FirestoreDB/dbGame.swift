//
//  dbGame.swift
//  CourtVision
//
//  Created by Aaron Nguyen on 12/3/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import Foundation
import Firebase


public class GameDM {
  var gameObj: [String : Any]
  
  init( _ homeTeamID: String, _ courtName: String, _ gameType: String, _ gameTime: String, _ gameAddress: String) {
    self.gameObj = [
      "courtInfo": [
        "image": "imageURLfromGoogleMaps",
        "courtName": courtName,
        "location": gameAddress
      ],
      "score": [
        "guestWin": false,
        "homeWin": false,
      ],
      "teams": [
        "guest": "",
        "home": homeTeamID
      ],
      "gameType": gameType,
      "time": gameTime
    ]
  }
}
