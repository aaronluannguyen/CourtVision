//
//  CreateGameViewController.swift
//  CourtVision
//
//  Created by Tejveer Rai on 12/6/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var GameName: UITextField!
    @IBOutlet weak var GameType: UITextField!
    @IBOutlet weak var GameTime: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerView: UIView!
    
    var typePickerData: [String] = ["3v3", "5v5"]
    var timePickerData: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                                      ["10", "20", "30", "40", "50", "00"],
                                      ["AM", "PM", "", ""]]
    var currentlyEditing : String = "Time";
    var rowSelected : Int = 0;
    var componentsInPicker : Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true;
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveSelection(_ sender: Any) {
        switch(currentlyEditing){
        case "Type":
            self.GameType.text = self.typePickerData[rowSelected]
        case "Time":
            self.GameTime.text = ""
            print("EDITING TIME")
        default:
            print("error")
        }
        
        pickerView.isHidden = true;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.componentsInPicker
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(self.currentlyEditing){
        case "Type":
            return typePickerData.count
        case "Time":
            return timePickerData.count
        default:
            print(self.currentlyEditing)
            return 1
        }
       
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      print("component: ")
      print(component)
      print("row: ")
      print(row)
      
      self.rowSelected = row
      if (self.currentlyEditing == "Type") {
          return self.typePickerData[row]
      } else {
        
          return self.timePickerData[component][row]
      }
    }
    
    @IBAction func EditName(_ sender: Any) {
        
    }
    
    @IBAction func EditType(_ sender: Any) {
        
    }
    
    @IBAction func EditTypeTouched(_ sender: Any) {
        pickerView.isHidden = false
        self.currentlyEditing = "Type"

        self.componentsInPicker = 1;
        self.picker.reloadAllComponents();
    }
    
    @IBAction func EditTimeTouched(_ sender: Any) {
        pickerView.isHidden = false
        self.currentlyEditing = "Time"
        self.componentsInPicker = 3;
        self.picker.reloadAllComponents();
    }
}
