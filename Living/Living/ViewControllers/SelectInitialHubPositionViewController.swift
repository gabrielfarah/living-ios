//
//  SelectInitialHubPositionViewController.swift
//  Living
//
//  Created by Nelson FB on 6/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

class SelectInitialHubPositionViewController:UIViewController, GMSMapViewDelegate{

    
    let mySpecialLocationNotificationKey = "com.arsmart.mySpecialLocationNotificationKey"
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    var firstLocationUpdate: Bool?
    var has_location:Bool  = false
    
    
    @IBOutlet weak var btn_continue: UIButton!
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: GMSMapView!
    
    func mapView(_ mapView: GMSMapView!, didTapAt coordinate: CLLocationCoordinate2D) {
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
        self.mapView.isMyLocationEnabled = true
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        self.navigationController?.isNavigationBarHidden = true
    }
    

    
    
    @IBAction func close(_ sender: AnyObject) {
        
        let location = [
            "lat":lat,
            "lon":lon,
            "hasLocation":has_location
        ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialLocationNotificationKey), object: location)
        self.dismiss(animated: true) {
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        lat = mapView.camera.target.latitude;
        lon = mapView.camera.target.longitude;
        ArSmartApi.sharedApi.hub!.latitude = lat
        ArSmartApi.sharedApi.hub!.longitude = lon
        print("location:", lat, lon)
        has_location = true
    }


}
extension SelectInitialHubPositionViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            has_location = true
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
            
            
        }
        
    }
}
