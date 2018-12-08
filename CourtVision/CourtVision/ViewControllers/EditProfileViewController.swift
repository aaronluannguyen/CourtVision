//
//  EditProfileViewController.swift
//  CourtVision
//
//  Created by Tejveer Rai on 12/7/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var PlayerName: UITextField!
    
    @IBOutlet weak var PlayerHeight: UITextField!
    @IBOutlet weak var PlayerWeight: UITextField!
    @IBOutlet weak var PlayerPosition: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func SaveSelection(_ sender: Any) {
        
    }
    
    @IBAction func EditHeightToucher(_ sender: Any) {
    }
    @IBAction func EditWeightTouched(_ sender: Any) {
    }
    @IBAction func EditPositionTouched(_ sender: Any) {
    }
    @IBAction func EditName(_ sender: Any) {
    }
    
    @IBAction func SaveProfile(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
