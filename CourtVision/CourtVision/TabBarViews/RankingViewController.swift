//
//  RankingViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/5/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //ViewController References
  @IBOutlet weak var teamsTableView: UITableView!
  
  //Variables
  var teams: [TeamDM] = [TeamDM("", "")]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    renderRankings()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return teams.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellID", for: indexPath) as! TeamTableViewCell
    
    let team = teams[indexPath.row]
    let teamRecord = team.teamObj["record"]! as! [String: Any]
    
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
      cell.txtRank.text = "\(indexPath.row)"
      cell.txtName.text = "\(team.teamObj["teamName"]! as! String)"
      cell.txtRecord.text = "\(teamRecord["wins"]!)-\(teamRecord["losses"]!)"
    }
    return cell
  }
  
  
  //Helper Functions
  func renderRankings() {
    getTeamRankings() {(teamsArray) in
      var teamsToSort = teamsArray
      teamsToSort.sort(by: {
        let item0Record = $0.teamObj["record"]! as! [String: Any]
        let item1Record = $1.teamObj["record"]! as! [String: Any]
        return self.winPercentage(item0Record["wins"]! as! Double, item0Record["totalGames"]! as! Double) > self.winPercentage(item1Record["wins"]! as! Double, item1Record["totalGames"]! as! Double)
      })
      self.teams.append(contentsOf: teamsToSort)
      self.teamsTableView.reloadData()
    }
  }
  
  func winPercentage(_ wins: Double, _ totalGames: Double) -> Double {
    return Double(wins / totalGames)
  }
}
