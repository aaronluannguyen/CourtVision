//
//  BrowseViewController.swift
//  CourtVision
//
//  Created by Anirudh Subramanyam on 12/6/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class BrowseViewController: UIViewController {
    
    
  @IBOutlet weak var scMapList: UISegmentedControl!
  
  var selectedPin: MKPlacemark? = nil
  
  var resultSearchController:UISearchController? = nil

  var currentPinView: MKAnnotationView? = nil

  @IBOutlet weak var mapView: MKMapView!

  //access to location manager
  let locationManager = CLLocationManager()

  var currentLocation:CLLocation? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    //to handle responses asynchronously
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //permission dialog
    locationManager.requestWhenInUseAuthorization()
    //location request only from iOS 9 and above.
    locationManager.requestLocation()
    
    let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable // table view controller
    resultSearchController = UISearchController(searchResultsController: locationSearchTable)
    resultSearchController?.searchResultsUpdater = locationSearchTable
    
    //configures search bar and embeds it within navigation bar
    let searchBar = resultSearchController!.searchBar
    searchBar.sizeToFit()
    searchBar.placeholder = "Search for a location"
    navigationItem.titleView = resultSearchController?.searchBar
    resultSearchController?.hidesNavigationBarDuringPresentation = false
    resultSearchController?.dimsBackgroundDuringPresentation = true
    definesPresentationContext = true
    
    locationSearchTable.mapView = mapView
    locationSearchTable.handleMapSearchDelegate = self
    
//    let location = CLLocationCoordinate2D(latitude: 37.784988, longitude: -122.407198)
//    let newGame: GameDM = GameDM("hometeamID", "Court Aaron", "5v5", "someDate", "someTime", MKPlacemark(coordinate: location))
//    newGame.newGame()
    getGamesListings(completion: <#T##([GameDM]) -> ()#>)
  }

  @IBAction func goToCurrentLoc(_ sender: Any) {
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) //zooom level
    let region = MKCoordinateRegion(center: currentLocation!.coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
}

extension BrowseViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) //zooom level
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

extension BrowseViewController : MKMapViewDelegate {
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
        currentPinView = pinView
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        currentPinView?.image = UIImage(named: "pin-white")
        view.image = UIImage(named: "pin-red")
        currentPinView = view
    }
}

extension BrowseViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        //        mapView.removeAnnotations(mapView.annotations) //remove existing pins        
        //MARK LOCATION
        let annotation = CustomPointAnnotation()
        annotation.pinCustomImageName = "pin-white"
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name!
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        
        //ZOOM IN TO PIN
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
