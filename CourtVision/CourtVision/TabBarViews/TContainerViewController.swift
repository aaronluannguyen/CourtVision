//
//  TContainerViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class TContainerViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    renderTeamView()
  }
  
  func renderTeamView() {
    getTeam() {(team) in
      if (team != nil) {
        self.performSegue(withIdentifier: "FromTContainerToTeam", sender: self)
      } else {
        self.performSegue(withIdentifier: "FromTContainerToNoTeam", sender: self)
      }
    }
  }
}
