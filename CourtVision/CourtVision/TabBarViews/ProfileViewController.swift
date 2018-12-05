//
//  ProfileViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/2/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gamesTableView.delegate = self
    gamesTableView.dataSource = self
//    gamesTableView.translatesAutoresizingMaskIntoConstraints = false
//    gamesTableView.leftAnchor.constraint(equalTo: view.leftAnchor)
//    gamesTableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    
    btnEdit.layer.cornerRadius = 2
    btnEdit.layer.borderWidth = 1
    btnEdit.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
    
    // Do any additional setup after loading the view.
    renderProfile()
    
//    let test = GameDM("teamID1", "IMA Court 1", "5v5", "dateString", "timeString", "gameAddress")
//    test.newGame()
    
//    getGamesHistoryFromTeam("teamID1")
  }

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 8
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellID", for: indexPath) as! GameTableViewCell
      cell.btnResult.backgroundColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0)
      cell.btnResult.layer.cornerRadius = 14
      cell.btnResult.layer.borderWidth = 1
      cell.btnResult.layer.borderColor = UIColor(red: 1, green: 164, blue: 0, alpha: 1.0).cgColor
      cell.imgGame.image = #imageLiteral(resourceName: "default")
      cell.txtLocation.text = "Ravenna Park"
      cell.txtTime.text = "Today, 10:00 am"
      return cell
  }


  //Helper Functions
  func renderProfile() {
    getPlayerProfile(UserDefaults.standard.string(forKey: UserDefaultsConstants.shared.udUserID)!) { (player) in
      if player != nil {
        let profile = player?.playerObj["profile"]! as! [String : Any]
        self.labelName.text = ("\(profile["firstName"]!) \(profile["lastName"]!)")
        self.labelHeight.text = ("\(profile["height"]!)")
        self.labelWeight.text = ("\(profile["weightPounds"]!)")
        self.labelPosition.text = ("\(profile["position"]!)")
      }
    }
  }
}
