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
    
    if checkUserHasTeam() {
      self.performSegue(withIdentifier: "FromTContainerToTeam", sender: self)
    } else {
      self.performSegue(withIdentifier: "FromTContainerToNoTeam", sender: self)
    }
  }
  
  func checkUserHasTeam() -> Bool {
    return (ud.string(forKey: udTeamID) != nil)
  }
}
