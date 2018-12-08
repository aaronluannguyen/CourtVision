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
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var typePickerData: [String] = ["3v3", "5v5"]
    
    var timePickerData: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                                      ["10", "20", "30", "40", "50", "00"],
                                      ["AM", "PM"]]
    var currentlyEditing : String = "Time";
    var rowSelected : Int = 0;
    var componentsInPicker : Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true;
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        GameName.leftView = paddingView
        GameName.leftViewMode = UITextField.ViewMode.always
        
        // Do any additional setup after loading the view.
    }

    @IBAction func SaveSelection(_ sender: Any) {
        pickerView.isHidden = true;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.componentsInPicker
        //return 3;
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(self.currentlyEditing){
        case "Type":
            return typePickerData.count
        case "Time":
            return timePickerData[component].count
        default:
            return 1
        }
       
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        print("Component: \(component) | Row: \(row) | Number: \(timePickerData[component][row])")
        print(" pickerView.selectedRow(inComponent: component): \(pickerView.selectedRow(inComponent: component))")
        
        var hour = "1"
        var minute = "10"
        var ampm = "AM"
        
        if(component == 0){
            hour = timePickerData[0][pickerView.selectedRow(inComponent: component)]
        }else if(component == 1){
            minute = timePickerData[1][pickerView.selectedRow(inComponent: component)]
        }else{
            ampm = timePickerData[2][pickerView.selectedRow(inComponent: component)]
        }
        
        let constructedTime = hour + ":" + minute + " " + ampm
        print(constructedTime)
        
        
      self.rowSelected = row
        
      if (self.currentlyEditing == "Type") {
        self.GameType.text = self.typePickerData[rowSelected]
        return self.typePickerData[row]
      } else {
        self.GameTime.text = constructedTime
        return self.timePickerData[component][row]
      }
    }
    
    @IBAction func EditName(_ sender: Any) {
        print(self.GameName.text)
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
