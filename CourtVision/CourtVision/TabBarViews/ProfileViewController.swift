//
//  ProfileViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  //ViewController References
  @IBOutlet weak var btnEdit: UIButton!
  @IBOutlet weak var gamesTableView: UITableView!
  
  //Profile References
  @IBOutlet weak var labelTotalGamesNum: UILabel!
  @IBOutlet weak var labelTotalWinsNum: UILabel!
  @IBOutlet weak var labelTotalLossesNum: UILabel!
  @IBOutlet weak var labelName: UILabel!
  @IBOutlet weak var labelHeight: UILabel!
  @IBOutlet weak var labelWeight: UILabel!
  @IBOutlet weak var labelPosition: UILabel!
  
  var profileListener: ListenerRegistration!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gamesTableView.delegate = self
    gamesTableView.dataSource = self
    gamesTableView.tableFooterView = UIView()
    
    btnEdit.layer.cornerRadius = 2
    btnEdit.layer.borderWidth = 1
    btnEdit.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    renderProfileView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    profileListener.remove()
  }
  
  //Variables
  var userTeamID: String = ""
  var gamesArray: [GameDM] = []

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return gamesArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellID", for: indexPath) as! GameTableViewCell
    cell.selectionStyle = .none
    
    let game = gamesArray[indexPath.row]
    let gameObj = game.gameObj

    let courtInfo = gameObj[courtInfoField]! as! [String : Any]
    
    let scoreResult = getGameTeamResult(game, userTeamID)
    cell.btnResult.isEnabled = false
    cell.btnResult.setTitle("\(scoreResult)", for: .normal)
    if (scoreResult == "Win") {
      cell.btnResult.backgroundColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0)
      cell.btnResult.layer.borderColor = UIColor(red: 1, green: 164, blue: 0, alpha: 1.0).cgColor
    } else {
      cell.btnResult.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
      cell.btnResult.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0).cgColor
    }
    cell.btnResult.layer.cornerRadius = 14
    cell.btnResult.layer.borderWidth = 1
    cell.imgGame.image = #imageLiteral(resourceName: "default")
    cell.txtLocation.text = "\(courtInfo[courtNameField]!)"
    cell.txtTime.text = "\(gameObj[datetimeField]!)"
    
    return cell
  }


  //Helper Functions
  func renderProfileView() {
    getPlayerProfile(ud.string(forKey: udUserID)!) { (player) in
      if player != nil {
        let profile = player?.playerObj[profileField]! as! [String : Any]
        self.labelTotalGamesNum.text = ("\(profile[totalGamesField]!)")
        self.labelTotalWinsNum.text = ("\(profile[totalWinsField]!)")
        self.labelTotalLossesNum.text = ("\(profile[totalLossesField]!)")
        
        self.labelName.text = ("\(profile[firstNameField]!) \(profile[lastNameField]!)")
        self.labelHeight.text = ("\(profile[heightField]!)")
        self.labelWeight.text = ("\(profile[weightPoundsField]!)")
        self.labelPosition.text = ("\(profile[positionField]!)")
        
        self.userTeamID = player?.playerObj[teamIDField]! as! String
        self.renderGamesHistoryLive()
      }
    }
  }
  
  func loadGamesHistory(_ teamID: String) {
    getGamesHistory(playersInvolvedField, ud.string(forKey: udUserID)!) { (allGames) in
      self.gamesArray = allGames
      self.gamesTableView.reloadData()
    }
  }
  
  //Listens for updates for player's game history LIVE
  public func renderGamesHistoryLive() {
    let db = getFirestoreDB()
    
    profileListener = db.collection(gamesCollection)
      .whereField(playersInvolvedField, arrayContains: ud.string(forKey: udUserID)!)
      .whereField("status", isEqualTo: gamesCompleted)
      .addSnapshotListener {(querySnapShot, error) in
        guard let documents = querySnapShot?.documents else {
          print("Error fetching game documents: \(String(describing: error))")
          return
        }
        for document in documents {
          let game = GameDM(document.data())
          if (!self.gamesArray.contains {
            $0.gameObj[gameIDField]! as! String == game.gameObj[gameIDField]! as! String
          }) {
            self.gamesArray.insert(game, at: 0)
            self.gamesTableView.reloadData()
          }
        }
      }
    }
    
    @IBAction func onEditProfileClick(_ sender: Any) {
        self.performSegue(withIdentifier: "FromProfileToEdit", sender: sender)
    }
    
}
