//
//  CreateGameMapViewController.swift
//  CourtVision
//
//  Created by Anirudh Subramanyam on 12/8/18.
//  Copyright © 2018 Aaron Nguyen. All rights reserved.
//

import UIKit
import MapKit

protocol HandleCreateGameSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class CreateGameMapViewController: UIViewController {
    let locationManager = CLLocationManager()
    var currentPlacemark: MKPlacemark? = nil
    @IBOutlet weak var mapView: MKMapView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CreateGameViewController
        destinationVC.currentPlacemark = currentPlacemark
        definesPresentationContext = false
    }
    
    var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let searchTable = storyboard!.instantiateViewController(withIdentifier: "CreateGameSearchTable") as! CreateGameSearchTable
        resultSearchController = UISearchController(searchResultsController: searchTable)
        resultSearchController?.searchResultsUpdater = searchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchTable.mapView = mapView
        searchTable.handleCreateGameSearch = self

    }
}

extension CreateGameMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) //zooom level
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

extension CreateGameMapViewController : MKMapViewDelegate {
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
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "pin-red")
    }
}

//address street line
//park name

extension CreateGameMapViewController: HandleCreateGameSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        mapView.removeAnnotations(mapView.annotations)
        currentPlacemark = placemark
        buildAnnotation(placemark: placemark)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func buildAnnotation(placemark: MKPlacemark) {
        let annotation = CustomPointAnnotation()
        annotation.pinCustomImageName = "pin-white"
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name        
        mapView.addAnnotation(annotation)
    }
}

