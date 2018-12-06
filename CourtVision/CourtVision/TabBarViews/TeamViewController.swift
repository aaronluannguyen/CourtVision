//
//  TeamViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  //ViewController References
  @IBOutlet weak var labelTeamName: UILabel!
  @IBOutlet weak var labelNumOfPlayers: UILabel!
  @IBOutlet weak var labelPlayers: UILabel!
  @IBOutlet weak var btnAdd: UIButton!
  @IBOutlet weak var playersTableView: UITableView!
  
  var teamMembers: [PlayerDM] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    btnAdd.layer.cornerRadius = 2
    btnAdd.layer.borderWidth = 1
    btnAdd.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
    
//    let team = TeamDM(ud.string(forKey: udUserID)!, "Team 1")
//    team.newTeam()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    renderTeamView()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return teamMembers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "playerCellID", for: indexPath) as! PlayerTableViewCell
  
    let player = teamMembers[indexPath.row]
    let playerProfile = player.playerObj["profile"]! as! [String: Any]
    
    cell.imgPlayer.image = #imageLiteral(resourceName: "default")
    cell.txtName.text = "\(playerProfile["firstName"]! as! String) \(playerProfile["lastName"]! as! String)"
    cell.txtPosition.text = "\(getPositionLongName(playerProfile["position"]! as! String))"

    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          deleteConfirmation(indexPath.row, indexPath)
      }
  }
  
  
  //Helper Functions

  func deleteConfirmation(_ index: Int, _ indexPath: IndexPath) {
    let alert = UIAlertController(title: "Are You Sure?", message: "You are about to delete this player from your team, is that correct?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: self.removePlayer(index, indexPath)))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }
  
  //Renders team view
  func renderTeamView() {
    getTeam() {(team) in
      if team != nil {
        self.labelTeamName.text = team?.teamObj["teamName"]! as! String
        let teamMembers = team?.teamObj["teamMembers"]! as! [String]
        self.labelNumOfPlayers.text = "\(teamMembers.count)"
        if (teamMembers.count <= 1) {
          self.labelPlayers.text = "Player"
        } else {
          self.labelPlayers.text = "Players"
        }
        
        self.loadTeamMembers()
      }
    }
  }
  
  //Renders player's team's members
  func loadTeamMembers() {
    getTeamMembers() {(playersArray) in
      self.teamMembers = playersArray
      self.playersTableView.reloadData()
    }
  }
  
  //Remove player from team
  func removePlayer(_ index: Int, _ indexPath: IndexPath) -> (_ alertAction: UIAlertAction) -> () {
    return {(action) in
      let playerToDelete = self.teamMembers[index]
      let playerToDeleteID = playerToDelete.playerObj["playerID"]! as! String
      deleteTeamMember(self, playerToDeleteID) {(playersArray) in
        if (playersArray.count < self.teamMembers.count) {
          self.teamMembers = playersArray
          self.playersTableView.deleteRows(at: [indexPath], with: .fade)
        }
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
