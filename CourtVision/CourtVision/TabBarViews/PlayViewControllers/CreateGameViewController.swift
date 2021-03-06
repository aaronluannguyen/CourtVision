//
//  CreateGameViewController.swift
//  CourtVision
//
//  Created by Tejveer Rai on 12/6/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class CreateGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

  @IBOutlet weak var GameName: UITextField!
  @IBOutlet weak var GameType: UITextField!
  @IBOutlet weak var GameTime: UITextField!
  @IBOutlet weak var GameLocation: UITextField!
  @IBOutlet weak var picker: UIPickerView!
  @IBOutlet weak var pickerView: UIView!
  @IBOutlet weak var btnSave: UIBarButtonItem!
  
  var currentPlacemark: MKPlacemark?
  
  var typePickerData: [String] = ["3v3", "5v5"]
  var timePickerData: [[String]]!
  var date = "Date"
  var time = "12:00"
  var ampm = "PM"
  var currentlyEditing : String = "Time";
  var rowSelected : Int = 0;
  var componentsInPicker : Int = 1;
  var createListener: ListenerRegistration?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let daysData: [String] = generateSevenDaysData()
    timePickerData = [daysData,
                      ["12:00", "12:15", "12:30", "12:45", "1:00", "1:15", "1:30", "1:45", "2:00", "2:15", "3:00", "3:15", "3:30", "3:45",
                       "4:00", "4:15", "4:30", "4:45", "5:00", "5:15", "5:30", "5:45", "6:00", "6:15", "6:30", "6:45",
                       "7:00", "7:15", "7:30", "7:45", "8:00", "8:15", "8:30", "8:45", "9:00", "9:15", "9:30", "9:45",
                       "10:00", "10:15", "10:30", "10:45", "11:00", "11:15", "11:30", "11:45"],
                      ["AM", "PM"]]
    pickerView.isHidden = true;
    self.picker.delegate = self
    self.picker.dataSource = self

    if currentPlacemark != nil {
      GameName.text = currentPlacemark?.name
      GameLocation.text = parseAddress(selectedItem: currentPlacemark!)
    }
    addTextfieldPadding()
    
    GameTime.delegate = self
    GameType.delegate = self
    GameLocation.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    listenToTeamCreateGame()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    createListener?.remove()
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
    
  func addTextfieldPadding() {
    let paddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
    GameName.rightView = paddingViewName
    GameName.rightViewMode = UITextField.ViewMode.always
    let paddingViewType = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
    GameType.rightView = paddingViewType
    GameType.rightViewMode = UITextField.ViewMode.always
    let paddingViewTime = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
    GameTime.rightView = paddingViewTime
    GameTime.rightViewMode = UITextField.ViewMode.always
    let paddingViewLocation = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
    GameLocation.rightView = paddingViewLocation
    GameLocation.rightViewMode = UITextField.ViewMode.always
  }

  @IBAction func onSaveCreateGameClick(_ sender: Any) {
    if (GameName.text! != "" && GameType.text! != "" && GameTime.text! != "" && GameLocation.text! != "" && self.time != "" && currentPlacemark != nil) {
      let newGame = GameDM(ud.string(forKey: udTeamID)!, GameName.text!, GameType.text!, GameTime.text!, currentPlacemark!, GameLocation.text!)
      createListener?.remove()
      newGame.newGame()
      performSegue(withIdentifier: "FromCreateGameToPlayVC", sender: nil)
    } else {
      let alert = UIAlertController(title: "Oops!", message: "You have not filled all the necessary information for creating a game.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
      self.present(alert, animated: true)
    }
  }

  @IBAction func SaveSelection(_ sender: Any) {
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
        return timePickerData[component].count
    default:
        return 1
    }
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if(component == 0){
        date = timePickerData[0][pickerView.selectedRow(inComponent: component)]
    }else if(component == 1){
        time = timePickerData[1][pickerView.selectedRow(inComponent: component)]
    }else{
        ampm = timePickerData[2][pickerView.selectedRow(inComponent: component)]
    }
    
    let constructedTime = "\(date), \(time) \(ampm)"
    self.rowSelected = row
      
    if (self.currentlyEditing == "Type") {
      self.GameType.text = self.typePickerData[rowSelected]
      return self.typePickerData[row]
    } else if (self.currentlyEditing == "Time") {
      self.GameTime.text = constructedTime
      return self.timePickerData[component][row]
    }
    return ""
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
    
  @IBAction func LocationAction(_ sender: Any) {
    performSegue(withIdentifier: "FromCreateToMap", sender: nil)
  }
  
  //Helper Functions
  
  func listenToTeamCreateGame() {
    let db = getFirestoreDB()
    
    createListener = db.collection(gamesCollection)
      .whereField(statusField, isEqualTo: gamesListing)
      .whereField(teamsField, arrayContains: ud.string(forKey: udTeamID)!)
      .addSnapshotListener {(querySnapShot, error) in
        guard let snapshot = querySnapShot else {
          print("Error fetching game documents: \(String(describing: error))")
          return
        }
        snapshot.documentChanges.forEach {diff in
          if (diff.type == .added) {
            let alert = UIAlertController(title: "Uh Oh!", message: "A teammate has just listed a game for your team.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in self.performSegue(withIdentifier: "FromCreateGameToPlayVC", sender: self)}))
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
  
  func generateSevenDaysData() -> [String] {
    let cal = Calendar.current
    // start with today
    var date = cal.startOfDay(for: Date())
  
    var days = [String]()
    
    for _ in 1 ... 7 {
      // get day component:
      let dayOfWeekInt = cal.component(.weekday, from: date)
      let year = cal.component(.year, from: date)
      let month = cal.component(.month, from: date)
      let day = cal.component(.day, from: date)
      days.append("\(self.getDayOfWeekName(dayOfWeekInt)), \(month)/\(day)/\(year)")
    
      // move forward in time by one day:
      date = cal.date(byAdding: .day, value: 1, to: date + 7)!
    }
    return days
  }
  
  func getDayOfWeekName(_ n: Int) -> String {
     switch n {
      case 1:
        return "Sun"
      case 2:
        return "Mon"
      case 3:
        return "Tue"
      case 4:
        return "Wed"
      case 5:
        return "Thurs"
      case 6:
        return "Fri"
      case 7:
        return "Sat"
      default:
        return ""
    }
  }
}
