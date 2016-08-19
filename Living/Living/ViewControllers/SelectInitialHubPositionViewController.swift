//
//  SelectInitialHubPositionViewController.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class SelectInitialHubPositionViewController:UIViewController, GMSMapViewDelegate{

    
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    
    
    @IBOutlet weak var btn_continue: UIButton!

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        lat = coordinate.latitude
        lon = coordinate.longitude
        
        ArSmartApi.sharedApi.hub!.latitude = coordinate.latitude
        ArSmartApi.sharedApi.hub!.longitude = coordinate.longitude
        
        let marker = GMSMarker(position: coordinate)
        marker.title = "Punto a Seleccionar"
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        self.navigationController?.navigationBarHidden = true

        
    }
    @IBAction func close(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }

}
extension SelectInitialHubPositionViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .AuthorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 6
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
}
