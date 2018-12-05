//
//  RankingViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/5/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var teamsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellID", for: indexPath) as! TeamTableViewCell
        cell.txtRank.text = "Rank"
        cell.txtName.text = "Teams"
        cell.txtRecord.text = "W-L"
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1.0)
            cell.txtRank.textColor = UIColor.white
            cell.txtName.textColor = UIColor.white
            cell.txtRecord.textColor = UIColor.white
            cell.selectionStyle = .none
        }
        return cell
    }

}
