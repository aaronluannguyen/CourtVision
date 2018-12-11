//
//  NoGameViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class NoGameViewController: UIViewController {

  @IBOutlet weak var navBackBtn: UINavigationItem!
  @IBOutlet weak var btnCreateGame: UIButton!
  
  var gameListingListener: ListenerRegistration?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // still renders initially
    navBackBtn.setHidesBackButton(true, animated: true)

    btnCreateGame.layer.cornerRadius = 3
    btnCreateGame.layer.borderWidth = 1
    btnCreateGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    listenToGameListing()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    gameListingListener?.remove()
  }
  
  func listenToGameListing() {
    let db = getFirestoreDB()
    
    gameListingListener = db.collection(gamesCollection)
      .whereField(statusField, isEqualTo: gamesListing)
      .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID)!)
      .addSnapshotListener {(querySnapShot, error) in
        guard let snapshot = querySnapShot else {
          print("Error fetching game documents: \(String(describing: error))")
          return
        }
        snapshot.documentChanges.forEach {diff in
          if (diff.type == .added) {
            let alert = UIAlertController(title: "New Game Listing!", message: "Your team has just posted a new game listing!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in self.performSegue(withIdentifier: "FromCreateToPlayContainer", sender: self)}))
            self.present(alert, animated: true)
            return
          }
          if (diff.type == .modified) {
            //Do nothing
          }
          if (diff.type == .removed) {
            //Do nothing
          }
        }
    }
  }
    
  @IBAction func onCreateGameClick(_ sender: Any) {
    self.performSegue(withIdentifier: "FromNoGameToCreate", sender: sender)
  }
}
