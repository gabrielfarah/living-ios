//
//  HomeRegister.swift
//  Living
//
//  Created by Nelson FB on 28/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//


import Foundation
import Presentr
import UIKit
import Localize_Swift

class HomeRegisterViewController: UIViewController {
    
    
    let mySpecialNotificationKey = "com.arsmart.specialNotificationKey"
    let mySpecialLocationNotificationKey = "com.arsmart.mySpecialLocationNotificationKey"
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var view_map: UIView!
    @IBOutlet weak var txt_name_home: UITextField!
    @IBOutlet weak var btn_photo: UIButton!
    @IBOutlet weak var img_place: UIImageView!
    
    
    
    var IsPhotoSelected:Bool = false
    var isLocationSelected:Bool = false
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeRegisterViewController.updateNotificationSentLabel), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeRegisterViewController.updateLocation), name: NSNotification.Name(rawValue: mySpecialLocationNotificationKey), object: nil)
        
        
    }
    func updateNotificationSentLabel(_ notification: Notification) {
        
        if(notification.object != nil){
            img_place.image = notification.object as? UIImage
            IsPhotoSelected = true

        }else{
            IsPhotoSelected = false
        }
        

    }
    func updateLocation(_ notification: Notification) {
        
        if(notification.object != nil){
            
            let values:[String:AnyObject] = notification.object as! [String:AnyObject]
            if((values["hasLocation"]) != nil){
                isLocationSelected = true
                lat = values["lat"] as! Double
                lon = values["lon"] as! Double
                let myLocation = CLLocation(latitude: lat, longitude: lon)
                mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }else{
                isLocationSelected = false
            }
            
            
        }else{
            isLocationSelected = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        self.navigationController?.isNavigationBarHidden = true
        btn_continue.layer.borderColor = UIColor("#D1D3D4").cgColor
        btn_continue.layer.borderWidth = 1.0

        
    }

    @IBAction func addPhoto(_ sender: AnyObject) {
    }

    @IBAction func SavePhotoAndContinue(_ sender: AnyObject) {
        
        if(txt_name_home.text!.isEmpty){
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("You must write the location's name".localized())
            
            
            
            
            
            
        }else if(!IsPhotoSelected){
        
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("You must chose an image for your location ...".localized())
        
        }else if(!isLocationSelected){
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("You must specify where is the location, please find your place in the map just dragging to it...".localized())
            
        }else{
            ArSmartApi.sharedApi.hub!.name = txt_name_home.text!
            performSegue(withIdentifier: "GoPreRegisterHub", sender: nil)
        }
        
        
    }
}
extension HomeRegisterViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            if(!isLocationSelected){
                locationManager.startUpdatingLocation()
                
                //5
                mapView.isMyLocationEnabled = true
                mapView.settings.myLocationButton = true
            
            }else{
            let myLocation = CLLocation(latitude: lat, longitude: lon)
             mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }

            
        }
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
}
