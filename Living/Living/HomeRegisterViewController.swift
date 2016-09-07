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
import EZLoadingActivity

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
        

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeRegisterViewController.updateNotificationSentLabel), name: mySpecialNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeRegisterViewController.updateLocation), name: mySpecialLocationNotificationKey, object: nil)
        
        
    }
    func updateNotificationSentLabel(notification: NSNotification) {
        
        if(notification.object != nil){
            img_place.image = notification.object as? UIImage
            IsPhotoSelected = true

        }else{
            IsPhotoSelected = false
        }
        

    }
    func updateLocation(notification: NSNotification) {
        
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
        
        self.navigationController?.navigationBarHidden = true
        btn_continue.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_continue.layer.borderWidth = 1.0

        
    }

    @IBAction func addPhoto(sender: AnyObject) {
    }

    @IBAction func SavePhotoAndContinue(sender: AnyObject) {
        
        if(txt_name_home.text!.isEmpty){
            
            let width = ModalSize.Custom(size: 240)
            let height = ModalSize.Custom(size: 130)
            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("Debe ingresar el nombre de un lugar")
            
            
            
            
            
            
        }else if(!IsPhotoSelected){
        
            let width = ModalSize.Custom(size: 240)
            let height = ModalSize.Custom(size: 130)
            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("Debe Seleccionar una imágen para su casa")
        
        }else if(!isLocationSelected){
            
            let width = ModalSize.Custom(size: 240)
            let height = ModalSize.Custom(size: 130)
            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("Debe especificar donde se encuentra el lugar, por favor presione sobre el mapa para elegir la ubucación.")
            
        }else{
            ArSmartApi.sharedApi.hub!.name = txt_name_home.text!
            performSegueWithIdentifier("GoPreRegisterHub", sender: nil)
        }
        
        
    }
}
extension HomeRegisterViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .AuthorizedWhenInUse {
            
            // 4
            if(!isLocationSelected){
                locationManager.startUpdatingLocation()
                
                //5
                mapView.myLocationEnabled = true
                mapView.settings.myLocationButton = true
            
            }else{
            let myLocation = CLLocation(latitude: lat, longitude: lon)
             mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }

            
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
