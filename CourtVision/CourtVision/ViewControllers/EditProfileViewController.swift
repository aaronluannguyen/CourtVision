//
//  EditProfileViewController.swift
//  CourtVision
//
//  Created by Tejveer Rai on 12/7/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var PlayerName: UITextField!
    @IBOutlet weak var PlayerHeight: UITextField!
    @IBOutlet weak var PlayerWeight: UITextField!
    @IBOutlet weak var PlayerPosition: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerView: UIView!
    
    var currentlyEditing : String = "Time"
    var rowSelected : Int = 0
    var componentsInPicker : Int = 1
    var pickerData: [String] = []
    var heights: [String] = [String]()
    var weights: [String] = [String]()
    var positions: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerView.isHidden = true
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = heights
        
        heights = ["4'0\"", "4'1\"", "4'2\"", "4'3\"",
        "4'4\"", "4'5\"", "4'6\"", "4'7\"",
        "4'8\"", "4'9\"", "4'10\"", "4'11\"",
        "5'0\"", "5'1\"", "5'2\"",
        "5'3\"", "5'4\"", "5'5\"", "5'6\"",
        "5'7\"", "5'8\"", "5'9\"", "5'10\"",
        "6'0\"", "6'1\"", "6'2\"", "6'3\"",
        "6'4\"", "6'5\"", "6'6\"", "6'7\"",
        "6'8\"", "6'9\"", "6'10\"", "6'11\"",
        "7'0\"", "7'1\"", "7'2\"", "7'3\"",
        "7'4\"", "7'5\"", "7'6\"", "7'7\"",
        "7'8\"", "7'9\"", "7'10\"", "7'11\""]
        
        for i in 50 ... 700 {
            weights.append(String(i) + " lb.")
        }
        
        positions = ["G", "PG", "SG", "F", "SF",
                     "PF", "C", "G/F", "PG/SG", "SG/SF",
                     "SF/PF", "PF/C"]
    }
    
    @IBAction func SaveSelection(_ sender: Any) {
        pickerView.isHidden = true;
    }
    
    @IBAction func EditName(_ sender: Any) {
        print(PlayerName.text)
    }
    
    @IBAction func EditHeightToucher(_ sender: Any) {
        pickerView.isHidden = false
        pickerData.removeAll(keepingCapacity: false)
        pickerData = heights
        currentlyEditing = "Height"
        self.picker.reloadAllComponents();
    }
    
    @IBAction func EditWeightTouched(_ sender: Any) {
        pickerView.isHidden = false
        pickerData.removeAll(keepingCapacity: false)
        print(pickerData)
        pickerData = weights
        print(pickerData)
        currentlyEditing = "Weight"
        self.picker.reloadAllComponents();
    }
    
    @IBAction func EditPositionTouched(_ sender: Any) {
        pickerView.isHidden = false
        pickerData.removeAll(keepingCapacity: false)
        pickerData = positions
        currentlyEditing = "Position"
        self.picker.reloadAllComponents();
    }
    
    @IBAction func SaveProfile(_ sender: Any) {
        
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        self.performSegue(withIdentifier: "FromEditToProfile", sender: sender)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(currentlyEditing){
        case "Height":
            self.PlayerHeight.text = pickerData[pickerView.selectedRow(inComponent: component)]
        case "Weight":
            self.PlayerWeight.text = pickerData[pickerView.selectedRow(inComponent: component)]
        case "Position":
            self.PlayerPosition.text = pickerData[pickerView.selectedRow(inComponent: component)]
        default:
            print("Error")
        }
        return pickerData[row]
    }
}
