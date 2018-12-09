//
//  SingleGameViewController.swift
//  CourtVision
//
//  Created by Wynston Hsu on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import MapKit

class SingleGameViewController: UIViewController {

  @IBOutlet weak var btnJoinGame: UIButton!
  @IBOutlet weak var btnMatch: UIButton!
  @IBOutlet weak var txtName: UILabel!
  @IBOutlet weak var txtTime: UILabel!
  @IBOutlet weak var txtTeam: UILabel!
  @IBOutlet weak var txtLocation: UILabel!
  
  @IBOutlet weak var mapView: MKMapView!
  var gameID : String?
  //for testing. comment out later
  var sentAnnotation: MKAnnotation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    btnMatch.isEnabled = false
    btnMatch.layer.cornerRadius = 14
    btnMatch.layer.borderWidth = 1
    btnMatch.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 0, alpha: 1.0).cgColor
    btnJoinGame.layer.cornerRadius = 3
    btnJoinGame.layer.borderWidth = 1
    btnJoinGame.layer.borderColor = UIColor(red: 246/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
    mapView.delegate = self
    queryGame()
  }
}

extension SingleGameViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
    if annotation is MKUserLocation {
        //return nil so map view draws "blue dot" for standard user location
        return nil
    }
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    if pinView == nil {
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = true
    } else {
        pinView?.annotation = annotation
    }
    
    let customPointAnnotation = annotation as! CustomPointAnnotation
    pinView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
//        currentPinView = pinView
    return pinView
  }
    
    //drop pin for each game
//    func dropGamePin(game: GameDM) {
//        let location = game.gameObj[locationField] as! [String : Any]
//        let lat = location[latField] as! Double
//        let long = location[longField] as! Double
//        let name = location[nameField] as! String
//
//        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: [nameField : name, gameIDField : game.gameObj[gameIDField]])
//        buildAnnotation(placemark: placemark)
//    }
  
  func queryGame() {
    getSingleGameListing(gameID!) {(game) in
      if (game != nil) {
        let gameObj = game!.gameObj
        self.txtTime.text = gameObj[datetimeField]! as? String
        let location = game!.gameObj[locationField]! as! [String: Any]
        self.txtName.text = location[nameField]! as? String
        self.txtLocation.text = location[addressField] as? String
        self.btnMatch.setTitle(gameObj[gameTypeField]! as? String, for: .normal)
        
        let teams = gameObj[teamsField]! as! [String]
        getTeamFromID(teams[0]) {(team) in
          self.txtTeam.text = team?.teamObj[teamNameField]! as? String
        }
        
        self.buildAnnotation(game!)
      }
    }
  }
    
  //drop a pin on the map.
  func buildAnnotation(_ game: GameDM) {
    let annotation = CustomPointAnnotation()
    annotation.pinCustomImageName = "pin-white"
    //use gameobject instead of sent annotation
    annotation.coordinate = sentAnnotation!.coordinate
    annotation.title = sentAnnotation!.title!
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: sentAnnotation!.coordinate, span: span)
    mapView.setRegion(region, animated: true)
    mapView.addAnnotation(annotation)
  }
}
