//
//  RankingViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/5/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //ViewController References
  @IBOutlet weak var teamsTableView: UITableView!
  
  //Variables
  var teams: [TeamDM] = [TeamDM("", "")]
  var listener: ListenerRegistration!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    teamsTableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    renderRankingsLive()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    listener.remove()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return teams.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellID", for: indexPath) as! TeamTableViewCell
    cell.isUserInteractionEnabled = false
    let team = teams[indexPath.row]
    let teamRecord = team.teamObj[recordField]! as! [String: Any]
    
    if indexPath.row == 0 {
      cell.txtRank.text = "Rank"
      cell.txtName.text = "Teams"
      cell.txtRecord.text = "W-L"
      cell.contentView.backgroundColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1.0)
      cell.txtRank.textColor = UIColor.white
      cell.txtName.textColor = UIColor.white
      cell.txtRecord.textColor = UIColor.white
      cell.selectionStyle = .none
    } else {
      if (team.teamObj[teamIDField]! as! String == ud.string(forKey: udTeamID)!) {
        cell.txtName.textColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0)
      }
      cell.txtRank.text = "\(indexPath.row)"
      cell.txtName.text = "\(team.teamObj[teamNameField]! as! String)"
      cell.txtRecord.text = "\(teamRecord[winsField]!)-\(teamRecord[lossesField]!)"
    }
    return cell
  }
  
  
  //Helper Functions
  func renderRankings() {
    getTeamRankings() {(teamsArray) in
      var teamsToSort = teamsArray
      teamsToSort.sort(by: {
        let item0Record = $0.teamObj[recordField]! as! [String: Any]
        let item1Record = $1.teamObj[recordField]! as! [String: Any]
        return
          self.winPercentage(item0Record[winsField]! as! Double, item0Record[totalGamesField]! as! Double)
          >
          self.winPercentage(item1Record[winsField]! as! Double, item1Record[totalGamesField]! as! Double)
      })
      self.teams.append(contentsOf: teamsToSort)
      self.teamsTableView.reloadData()
    }
  }
  
  //Returns all teams for in order of rank based on W/L record LIVE
  public func renderRankingsLive() {
    let db = getFirestoreDB()
    
    listener = db.collection(teamsCollection).addSnapshotListener {(querySnapShot, error) in
      guard let documents = querySnapShot?.documents else {
        print("Error fetching team documents: \(String(describing: error))")
        return
      }
      var teamsToSort: [TeamDM] = []
      for document in documents {
        teamsToSort.append(TeamDM(document.data()))
      }
      teamsToSort.sort(by: {
        let item0Record = $0.teamObj[recordField]! as! [String: Any]
        let item1Record = $1.teamObj[recordField]! as! [String: Any]
        return
          self.winPercentage(item0Record[winsField]! as! Double, item0Record[totalGamesField]! as! Double)
            >
            self.winPercentage(item1Record[winsField]! as! Double, item1Record[totalGamesField]! as! Double)
      })
      self.teams = [TeamDM("", "")]
      self.teams.append(contentsOf: teamsToSort)
      self.teamsTableView.reloadData()
    }
  }
  
  func winPercentage(_ wins: Double, _ totalGames: Double) -> Double {
    return Double(wins / totalGames)
  }
}
