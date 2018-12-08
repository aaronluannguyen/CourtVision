//
//  NoTeamViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase

class NoTeamViewController: UIViewController {

  @IBOutlet weak var navBackBtn: UINavigationItem!
  @IBOutlet weak var labelAddCode: UILabel!
  @IBOutlet weak var btnCreateTeam: UIButton!
  
  var listener: ListenerRegistration!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // still renders initially
    navBackBtn.setHidesBackButton(true, animated: true)

    btnCreateTeam.layer.cornerRadius = 3
    btnCreateTeam.layer.borderWidth = 1
    btnCreateTeam.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    
    getPlayerAddCode()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    listenForPlayerTeamUpdates()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    listener.remove()
  }
  
  
  @IBAction func onCreateTeamClick(_ sender: Any) {
    let alert = UIAlertController(title: "Create a Team", message: "What will your team be called?", preferredStyle: .alert)
    alert.addTextField {(textField) in
      textField.text = ""
      textField.keyboardType = .numberPad
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
      let tfTeamName = alert.textFields![0].text!
      if (tfTeamName.count > 0) {
        self.createNewTeam(tfTeamName)
      }
    }))
    self.present(alert, animated: true)
  }
  
  //Get and updates labelAddCode text with player's add code
  func getPlayerAddCode() {
    getPlayerProfile(ud.string(forKey: udUserID)!) {(player) in
      if (player != nil) {
        self.labelAddCode.text = player?.playerObj[addCodeField]! as? String
      } else {
        print("Error retrieving player add code.")
      }
    }
  }
  
  //Create's new team and updates Firestore DB
  func createNewTeam(_ teamName: String) {
    let team = TeamDM(ud.string(forKey: udUserID)!, teamName)
    team.newTeam()
    self.performSegue(withIdentifier: "FromNoTeamToTeam", sender: self)
  }
  
  func listenForPlayerTeamUpdates() {
    let db = getFirestoreDB()
    listener = db.collection(playersCollection).document(ud.string(forKey: udUserID)!)
      .addSnapshotListener(includeMetadataChanges: true) {(docSnapShot, error) in
        if (error == nil) {
          let player = PlayerDM(docSnapShot!.data() as! [String: Any])
          let teamID = player.playerObj[teamIDField]! as? String
          if (teamID != "") {
            ud.set(teamID, forKey: udTeamID)
            getTeam() {(team) in
              if (team != nil) {
                self.performSegue(withIdentifier: "FromNoTeamToTeam", sender: self)
              }
            }
          }
        }
      }
  }
}
