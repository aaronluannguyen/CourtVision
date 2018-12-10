//
//  ListingViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class ListingViewController: UIViewController {

  @IBOutlet weak var navBackBtn: UINavigationItem!
  @IBOutlet weak var btnMatch: UIButton!
  @IBOutlet weak var txtName: UILabel!
  @IBOutlet weak var txtTime: UILabel!
  @IBOutlet weak var txtTeam: UILabel!
  @IBOutlet weak var txtLocation: UILabel!
  @IBOutlet weak var btnDeleteGame: UIButton!
  
  var listingListener: ListenerRegistration?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // still renders initially
    navBackBtn.setHidesBackButton(true, animated: true)
    btnMatch.isEnabled = false
    btnMatch.layer.cornerRadius = 14
    btnMatch.layer.borderWidth = 1
    btnMatch.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor

    btnDeleteGame.layer.cornerRadius = 3
    btnDeleteGame.layer.borderWidth = 1
    btnDeleteGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    listenToListing()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    listingListener?.remove()
  }
  
  func listenToListing() {
    let db = getFirestoreDB()
    let gamesRef = db.collection(gamesCollection)
    
    let games = gamesRef
      .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID))
      .whereField("status", isEqualTo: gamesListing)
    
    games.getDocuments() {(query, err) in
      if let err = err {
        print("Error: \(err)")
      } else {
        let game = GameDM(query!.documents[0].data())
        let gameRef = db.collection(gamesCollection).document(game.gameObj[gameIDField]! as! String)
        self.listingListener = gameRef.addSnapshotListener {(documentSnapshot, error) in
          guard let document = documentSnapshot else {
            print("Error: \(String(describing: error))")
            return
          }
          guard let data = document.data() else {
            print("Error: \(String(describing: error))")
            return
          }
          let gameListing = GameDM(data)
          if (gameListing.gameObj[statusField]! as! String == gamesActive || gameListing.gameObj[statusField]! as! String == gamesDeleted) {
            self.performSegue(withIdentifier: "FromListingToPlayContainer", sender: self)
            return
          }
          let courtInfo = game.gameObj[courtInfoField]! as! [String: Any]
          self.txtName.text = courtInfo[courtNameField]! as? String
          self.txtTime.text = game.gameObj[datetimeField]! as? String
          self.txtTeam.text = "Pending Team"
          self.btnMatch.setTitle(game.gameObj[gameTypeField]! as? String, for: .normal)
          let location = game.gameObj[locationField]! as! [String: Any]
          self.txtLocation.text = location[addressField]! as? String
        }
      }
    }
  }
  
  
  @IBAction func deleteListingClick(_ sender: Any) {
    let db = getFirestoreDB()
    let gamesRef = db.collection(gamesCollection)
    
    let games = gamesRef
      .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID)!)
      .whereField("status", isEqualTo: gamesListing)
    
    games.getDocuments() {(query, err) in
      if let err = err {
        print("Error: \(err)")
      } else {
        let game = GameDM(query!.documents[0].data())
        let gameRef = db.collection(gamesCollection).document(game.gameObj[gameIDField]! as! String)
        gameRef.updateData([
          statusField: gamesDeleted
        ])
      }
    }
  }
}
