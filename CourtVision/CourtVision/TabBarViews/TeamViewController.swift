//
//  TeamViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/4/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  @IBOutlet weak var txtNumb: UILabel!
  @IBOutlet weak var btnAdd: UIButton!
  @IBOutlet weak var playersTableView: UITableView!
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    btnAdd.layer.cornerRadius = 2
    btnAdd.layer.borderWidth = 1
    btnAdd.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
    
//    let team = TeamDM(ud.string(forKey: udUserID)!, "Team 1")
//    team.newTeam()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "playerCellID", for: indexPath) as! PlayerTableViewCell
      cell.imgPlayer.image = #imageLiteral(resourceName: "default")
      cell.txtName.text = "Aaron Nguyen"
      cell.txtPosition.text = "Point Guard"
      self.count += 1
      txtNumb.text = String(self.count)
      return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          //replace self.tableArray with firebase data array; currently doesn't actually remove row only shows button
//            self.tableArray.remove(at: indexPath.row)
          print("click!")
          deleteConfirmation()
//            tableView.deleteRows(at: [indexPath], with: .fade)
          print("clicked!")
      }
  }

  func deleteConfirmation() {
      let alert = UIAlertController(title: "Are You Sure?", message: "You are about to delete a player from your team, is that correct?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
      self.present(alert, animated: true)
  }
}
