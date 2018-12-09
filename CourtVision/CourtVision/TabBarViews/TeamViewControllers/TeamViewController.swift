//
//  TeamViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var navBackBtn: UINavigationItem!
    //ViewController References
  @IBOutlet weak var labelTotalGamesNum: UILabel!
  @IBOutlet weak var labelTotalWinsNum: UILabel!
  @IBOutlet weak var labelTotalLossesNum: UILabel!
  @IBOutlet weak var labelTeamName: UILabel!
  @IBOutlet weak var labelNumOfPlayers: UILabel!
  @IBOutlet weak var labelPlayers: UILabel!
  @IBOutlet weak var btnAddPlayer: UIButton!
  @IBOutlet weak var playersTableView: UITableView!
  @IBOutlet weak var segmentControlPlayersGames: UISegmentedControl!
  
  var teamMembers: [PlayerDM] = []
  var teamGamesHistory: [GameDM] = []
  var teamPlayerSideListener: ListenerRegistration!
  var teamUpdateListener: ListenerRegistration!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // still renders initially
    navBackBtn.setHidesBackButton(true, animated: true)
    
    playersTableView.tableFooterView = UIView()
    
    btnAddPlayer.layer.cornerRadius = 2
    btnAddPlayer.layer.borderWidth = 1
    btnAddPlayer.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    renderTeamView()
    listenForPlayerTeamUpdates()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    teamPlayerSideListener.remove()
    teamUpdateListener.remove()
  }
  
  @IBAction func scActionHandler(_ sender: Any) {
    let scSubviews: [UIView] = segmentControlPlayersGames.subviews
    if (segmentControlPlayersGames.selectedSegmentIndex == 0) {
      //@Wynston More custom color control here for segment controller. But play around more to just adjust the inner box fill as well as text color
//      scSubviews[0].backgroundColor = UIColor.red
//      scSubviews[0].tintColor = UIColor.white
//      scSubviews[1].backgroundColor = UIColor.init(red: 248/255, green: 113/255, blue: 113/255, alpha: 1.0)
//      scSubviews[1].tintColor = UIColor.white
      self.loadTeamMembers()
    } else {
      //@Wynston More custom color control here for segment controller. But play around more to just adjust the inner box fill as well as text color
//      scSubviews[1].backgroundColor = UIColor.red
//      scSubviews[1].tintColor = UIColor.white
//      scSubviews[0].backgroundColor = UIColor.init(red: 248/255, green: 113/255, blue: 113/255, alpha: 1.0)
//      scSubviews[0].tintColor = UIColor.white
      self.loadTeamGamesHistory()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (segmentControlPlayersGames.selectedSegmentIndex == 0) {
      return teamMembers.count
    } else {
      return teamGamesHistory.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (segmentControlPlayersGames.selectedSegmentIndex == 0) {
      let cell = tableView.dequeueReusableCell(withIdentifier: "playerCellID", for: indexPath) as! PlayerTableViewCell
      
      let player = teamMembers[indexPath.row]
      let playerProfile = player.playerObj[profileField]! as! [String: Any]

      cell.imgPlayer.image = #imageLiteral(resourceName: "default")
      cell.txtName.text = "\(playerProfile[firstNameField]! as! String) \(playerProfile[lastNameField]! as! String)"
      cell.txtPosition.text = "\(getPositionLongName(playerProfile[positionField]! as! String))"
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellID", for: indexPath) as! GameTableViewCell
      cell.selectionStyle = .none
      
      let game = teamGamesHistory[indexPath.row]
      let gameObj = game.gameObj
      let courtInfo = gameObj[courtInfoField]! as! [String : Any]
      
      let scoreResult = getGameTeamResult(game, ud.string(forKey: udTeamID)!)
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
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        deleteConfirmation(indexPath.row, indexPath)
      }
  }
  
  @IBAction func btnAddPlayerClick(_ sender: Any) {
    let alert = UIAlertController(title: "Add a Player to \(self.labelTeamName.text!)", message: "Please enter your desired player's unique add code.", preferredStyle: .alert)
    alert.addTextField {(textField) in
      textField.text = ""
      textField.keyboardType = .numberPad
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in self.addPlayer(alert.textFields![0].text!)}))
    self.present(alert, animated: true)
  }
  
  //Helper Functions

  func deleteConfirmation(_ index: Int, _ indexPath: IndexPath) {
    let alert = UIAlertController(title: "Are You Sure?", message: "You are about to delete this player from your team, is that correct?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in self.removePlayer(index, indexPath)}))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }
  
  //Listens for updates in case they're removed from the team
  func listenForPlayerTeamUpdates() {
    let db = getFirestoreDB()
    //Listens to team updates by monitoring player's teamID field
    teamPlayerSideListener = db.collection(playersCollection).document(ud.string(forKey: udUserID)!)
      .addSnapshotListener(includeMetadataChanges: true) {(docSnapShot, error) in
        if (error == nil) {
          let player = PlayerDM(docSnapShot!.data() as! [String: Any])
          let teamID = player.playerObj[teamIDField]! as? String
          if (teamID == "") {
            ud.set("", forKey: udTeamID)
            self.performSegue(withIdentifier: "FromTeamToNoTeam", sender: self)
          }
        }
    }
    //Listens to team updates by monitoring team's document in Firestore
    teamUpdateListener = db.collection(teamsCollection).document(ud.string(forKey: udTeamID)!)
      .addSnapshotListener(includeMetadataChanges: true) {(docSnapShot, error) in
        self.renderTeamView()
      }
  }
  
  //Renders team view
  func renderTeamView() {
    getTeam() {(team) in
      if team != nil {
        self.labelTeamName.text = team?.teamObj[teamNameField]! as? String
        let teamRecord = team?.teamObj[recordField]! as! [String : Any]
        self.labelTotalGamesNum.text = "\(teamRecord[totalGamesField]!)"
        self.labelTotalWinsNum.text = "\(teamRecord[winsField]!)"
        self.labelTotalLossesNum.text = "\(teamRecord[lossesField]!)"
        
        let teamMembers = team?.teamObj[teamMembersField]! as! [String]
        self.labelNumOfPlayers.text = "\(teamMembers.count)"
        if (teamMembers.count <= 1) {
          self.labelPlayers.text = "Player"
        } else {
          self.labelPlayers.text = "Players"
        }
      }
    }
    scActionHandler(self)
  }
  
  //Renders team's games history
  func loadTeamGamesHistory() {
    getGamesHistory(teamsField, ud.string(forKey: udTeamID)!) { (allGames) in
      self.teamGamesHistory = allGames
      self.playersTableView.reloadData() //playersTableView is just set table. Not limited to just displaying players
    }
  }
  
  //Renders player's team's members
  func loadTeamMembers() {
    getTeamMembers() {(playersArray) in
      self.teamMembers = playersArray
      self.playersTableView.reloadData()
    }
  }
  
  //Add player to team
  func addPlayer(_ addCode: String) {
    addTeamMember(self, addCode) {(playersArray) in
      if (playersArray.count > self.teamMembers.count) {
        self.teamMembers = playersArray
        self.playersTableView.reloadData()
      }
    }
  }
  
  //Remove player from team
  func removePlayer(_ index: Int, _ indexPath: IndexPath) {
    let playerToDelete = self.teamMembers[index]
    let playerToDeleteID = playerToDelete.playerObj[playerIDField]! as! String
    deleteTeamMember(self, playerToDeleteID) {(playersArray) in
      if (playersArray.count < self.teamMembers.count) {
        self.teamMembers = playersArray
        self.playersTableView.deleteRows(at: [indexPath], with: .fade)
      }
    }
  }
  
  //Returns back the long version of a position type
  func getPositionLongName(_ position: String) -> String {
    switch position {
      case "G":
        return "Guard"
      case "PG":
        return "Point Guard"
      case "SG":
        return "Shooting Guard"
      case "PG/SG":
        return "Point Guard / Shooting Guard"
      case "F":
        return "Forward"
      case "SF":
        return "Small Forward"
      case "PF":
        return "Power Forward"
      case "SF/PF":
        return "Shooting Forward / Power Forward"
      case "C":
        return "Center"
      case "PF/C":
        return "Power Forward / Center"
      default:
        return "N/A"
    }
  }
}
