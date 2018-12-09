//
//  PlayViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase


class PlayViewController: UIViewController {
  
  var gameListingListener: ListenerRegistration!
  var gameActiveListener: ListenerRegistration!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    rerouteActiveView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    gameListingListener.remove()
    if (gameActiveListener != nil) {
      gameActiveListener.remove()
    }
  }
//      self.performSegue(withIdentifier: "FromActiveToLive", sender: self)
  //    self.performSegue(withIdentifier: "FromActiveToCreate", sender: self)
  //    self.performSegue(withIdentifier: "FromActiveToListing", sender: self)
  
  func rerouteActiveView() {
    if (ud.string(forKey: udTeamID)! == "") {
      let alert = UIAlertController(title: "No Team", message: "You must create a team or be invited to one before you can play.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in self.performSegue(withIdentifier: "FromActiveToNoTeam", sender: self)}))
      self.present(alert, animated: true)
    }
    
    let db = getFirestoreDB()
    
    gameListingListener = db.collection(gamesCollection)
      .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID)!)
      .whereField("status", isEqualTo: gamesListing)
      .addSnapshotListener {(querySnapShot, error) in
        guard let documents = querySnapShot?.documents else {
          print("Error fetching game documents: \(String(describing: error))")
          return
        }
        if (documents.count == 0) {
          self.gameActiveListener = db.collection(gamesCollection)
            .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID)!)
            .whereField("status", isEqualTo: gamesActive)
            .addSnapshotListener {(querySnapShot, error) in
              guard let documentsActive = querySnapShot?.documents else {
                print("Error fetching game documents: \(String(describing: error))")
                return
              }
              if (documentsActive.count == 0) {
                print("FUCK")
                self.performSegue(withIdentifier: "FromActiveToCreate", sender: self)
              } else {
                self.performSegue(withIdentifier: "FromActiveToLive", sender: self)
              }
            }
        } else {
          //Assuming only home team has listings with teams array containing their team
          self.performSegue(withIdentifier: "FromActiveToListing", sender: self)
        }
    }
  }
}
