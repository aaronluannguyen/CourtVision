//
//  EditProfileViewController.swift
//  CourtVision
//
//  Created by Tejveer Rai on 12/7/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import Firebase

//extension String {
//    var containsWhitespace : Bool {
//        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
//    }
//
//    func chopPrefix(_ count: Int = 1) -> String {
//        return substring(from: index(startIndex, offsetBy: count))
//    }
//}
//
//extension StringProtocol where Index == String.Index {
//    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
//        return range(of: string, options: options)?.lowerBound
//    }
//}

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var PlayerFName: UITextField!
    @IBOutlet weak var PlayerLName: UITextField!
    @IBOutlet weak var PlayerHeight: UITextField!
    @IBOutlet weak var PlayerWeight: UITextField!
    @IBOutlet weak var PlayerPosition: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerView: UIView!
    
    var currentlyEditing : String = "Height"
    var rowSelected : Int = 0
    var componentsInPicker : Int = 1
    var heightPickerData: [[String]]!
    var pickerData: [String] = []
//    var heights: [[String]] = [[String]]()
    var weights: [String] = [String]()
    var positions: [String] = [String]()
    var ft = "ft"
    var inch = "in"
//    var fullName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerView.isHidden = true
        self.picker.delegate = self
        self.picker.dataSource = self
        heightPickerData = [["4'", "5'", "6'", "7'"], ["0\"", "1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "10\"", "11\""]]
        
        for i in 50 ... 500 {
            weights.append(String(i) + " lb.")
        }
        
        // check if positions match in db
        positions = ["G", "PG", "SG", "F", "SF",
                     "PF", "C", "PG/SG", "SG/SF",
                     "SF/PF", "PF/C"]
        
        getPlayerProfile(ud.string(forKey: udUserID)!) { (player) in
            if player != nil {
                let profile = player?.playerObj[profileField]! as! [String : Any]
                
                self.PlayerFName.text = ("\(profile[firstNameField]!)")
                self.PlayerLName.text = ("\(profile[lastNameField]!)")
                self.PlayerHeight.text = ("\(profile[heightField]!)")
                self.PlayerWeight.text = ("\(profile[weightPoundsField]!)")
                self.PlayerPosition.text = ("\(profile[positionField]!)")
            }
        }
        
        addTextfieldPadding()
    }
    
    func addTextfieldPadding() {
        let paddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        PlayerFName.rightView = paddingViewName
        PlayerFName.rightViewMode = UITextField.ViewMode.always
        let paddingViewLName = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        PlayerLName.rightView = paddingViewLName
        PlayerLName.rightViewMode = UITextField.ViewMode.always
        let paddingViewHeight = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        PlayerHeight.rightView = paddingViewHeight
        PlayerHeight.rightViewMode = UITextField.ViewMode.always
        let paddingViewWeight = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        PlayerWeight.rightView = paddingViewWeight
        PlayerWeight.rightViewMode = UITextField.ViewMode.always
        let paddingViewPosition = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        PlayerPosition.rightView = paddingViewPosition
        PlayerPosition.rightViewMode = UITextField.ViewMode.always
    }
    
    @IBAction func SaveSelection(_ sender: Any) {
        pickerView.isHidden = true;
    }
    
    @IBAction func EditName(_ sender: Any) {
        pickerView.isHidden = true;
        print(PlayerFName.text!)
        print(PlayerLName.text!)
    }
    
    @IBAction func EditHeightToucher(_ sender: Any) {
        pickerView.isHidden = false
//        heightPickerData.removeAll(keepingCapacity: false)
//        heightPickerData = heights
        currentlyEditing = "Height"
        componentsInPicker = 2
        self.picker.reloadAllComponents();
    }
    
    @IBAction func EditWeightTouched(_ sender: Any) {
        pickerView.isHidden = false
        pickerData.removeAll(keepingCapacity: false)
        pickerData = weights
        currentlyEditing = "Weight"
        componentsInPicker = 1
        self.picker.reloadAllComponents();
    }
    
    @IBAction func EditPositionTouched(_ sender: Any) {
        pickerView.isHidden = false
        pickerData.removeAll(keepingCapacity: false)
        pickerData = positions
        currentlyEditing = "Position"
        componentsInPicker = 1
        self.picker.reloadAllComponents();
    }
    
    @IBAction func SaveProfile(_ sender: Any) {
//        if (checkNameFormat()) {
//            let index = fullName.index(of: " ")
//            let firstName = fullName.prefix(upTo: index!)
//            let lastName = fullName.chopPrefix(index)
//            print(firstName)
//            print(lastName)
//
//        }
        getFirestoreDB().collection(playersCollection).document(ud.string(forKey: udUserID)!).updateData([
            "profile.firstName": self.PlayerFName.text!,
            "profile.lastName": self.PlayerLName.text!,
            "profile.height": self.PlayerHeight.text!,
            "profile.weight": self.PlayerWeight.text!,
            "profile.position": self.PlayerPosition.text!
            ])
        self.performSegue(withIdentifier: "FromEditToProfile", sender: sender)
    }
    
//    func checkNameFormat() -> Bool {
//        self.fullName = self.PlayerName.text!
//        let whitespace = NSCharacterSet.whitespaces
//        if !fullName.containsWhitespace {
//            print("doesn't contains space!")
//            let alert = UIAlertController(title: "Uh oh!", message: "Looks like the name you entered isn't in proper format. Please try again!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true)
//            return false
//        } else {
//            print("contains space!")
//            return true
//        }
//    }
    
    @IBAction func onBackClick(_ sender: Any) {
        self.performSegue(withIdentifier: "FromEditToProfile", sender: sender)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.componentsInPicker
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(self.currentlyEditing){
        case "Height":
            return heightPickerData[component].count
        case "Weight":
            return pickerData.count
        case "Position":
            return pickerData.count
        default:
            return 1
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (currentlyEditing == "Height") {
            if (component == 0) {
                ft = heightPickerData[0][pickerView.selectedRow(inComponent: component)]
            } else {
                inch = heightPickerData[1][pickerView.selectedRow(inComponent: component)]
            }
            self.PlayerHeight.text = "\(ft) \(inch)"
            return self.heightPickerData[component][row]
        } else {
            switch(currentlyEditing){
            case "Weight":
                self.PlayerWeight.text = pickerData[row]
            case "Position":
                self.PlayerPosition.text = pickerData[row]
            default:
                print("Error")
            }
            return pickerData[row]
        }
    }
}
