//
//  LiveGameViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class LiveGameViewController: UIViewController {

  @IBOutlet weak var navBackBtn: UINavigationItem!
  @IBOutlet weak var imgLocation: UIImageView!
  @IBOutlet weak var btnMatch: UIButton!
  @IBOutlet weak var txtName: UILabel!
  @IBOutlet weak var txtTime: UILabel!
  @IBOutlet weak var txtTeam: UILabel!
  @IBOutlet weak var txtLocation: UILabel!
  @IBOutlet weak var btnWin: UIButton!
  @IBOutlet weak var btnLoss: UIButton!
  @IBOutlet weak var container: UIView!
    
  
  var activeListener: ListenerRegistration?
  var currGame: GameDM?
  var opponentTeam: TeamDM?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // still renders initially
    navBackBtn.setHidesBackButton(true, animated: true)
    btnMatch.isEnabled = false
    btnMatch.layer.cornerRadius = 14
    btnMatch.layer.borderWidth = 1
    btnMatch.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    listenToActiveGame()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    activeListener?.remove()
  }
    
  @IBAction func onWinClick(_ sender: Any) {
    let alert = UIAlertController(title: "Congratulations!", message: "You are about to record a win for your team, is that correct?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
      if (self.currGame != nil) {
        completeGame(self.currGame!, true, false)
      }
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }
  
  @IBAction func onLossClick(_ sender: Any) {
    let alert = UIAlertController(title: "Nice Try", message: "You are about to record a loss for your team, is that correct?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
      if (self.currGame != nil) {
        completeGame(self.currGame!, false, true)
      }
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }

  //Get single active game
  func listenToActiveGame() {
    getSingleActiveGame() {(activeGame) in
      if (activeGame != nil) {
        let db = getFirestoreDB()
        self.activeListener = db.collection(gamesCollection).document(activeGame?.gameObj[gameIDField]! as! String)
          .addSnapshotListener {(documentSnapshot, error) in
            guard let document = documentSnapshot else {
              print("Error: \(String(describing: error))")
              return
            }
            guard let data = document.data() else {
              print("Error: \(String(describing: error))")
              return
            }
            let game = GameDM(data)
            self.getTeamHomeOrGuest(game)
            self.currGame = game
            if (game.gameObj[statusField]! as! String != gamesActive) {
              //Alert on game winner/loser
              self.performSegue(withIdentifier: "FromPlayToPlayContainer", sender: self)
            }
            let courtInfo = game.gameObj[courtInfoField]! as! [String: Any]
            self.txtName.text = courtInfo[courtNameField]! as? String
            self.txtTime.text = game.gameObj[datetimeField]! as? String
            getTeamFromID(getGameOpponentTeamID(game, ud.string(forKey: udTeamID)!)) {(team) in
              self.opponentTeam = team
              self.txtTeam.text = team?.teamObj[teamNameField]! as? String
            }
            self.btnMatch.setTitle(game.gameObj[gameTypeField]! as? String, for: .normal)
            let location = game.gameObj[locationField]! as! [String: Any]
            self.txtLocation.text = location[addressField]! as? String
          }
      } else {
        
      }
    }
  }
  
  //Update hidden variable depending if user is on home or guest team
  func getTeamHomeOrGuest(_ game: GameDM) {
    let teams = game.gameObj[teamsField]! as! [String]
    if (ud.string(forKey: udTeamID)! == teams[0]) {
      container.isHidden = false
      btnWin.layer.cornerRadius = 10
      btnWin.layer.borderWidth = 1
      btnWin.layer.backgroundColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
      btnWin.layer.borderColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
      btnLoss.layer.cornerRadius = 10
      btnLoss.layer.borderWidth = 1
      btnLoss.layer.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
      btnLoss.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
    } else {
      container.isHidden = true
      btnWin.isEnabled = false
      btnLoss.isEnabled = false
      //Add message about being guest team
    }
  }
}
