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
    
    
    let mySpecialNotificationKey = "com.andrewcbancroft.specialNotificationKey"
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var view_map: UIView!
    @IBOutlet weak var txt_name_home: UITextField!
    @IBOutlet weak var btn_photo: UIButton!
        @IBOutlet weak var img_place: UIImageView!
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //ArSmartApi.sharedApi.token?.CheckTokenTest()
        
     NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeRegisterViewController.updateNotificationSentLabel), name: mySpecialNotificationKey, object: nil)
        
        
        
    }
    func updateNotificationSentLabel(notification: NSNotification) {
        img_place.image = notification.object as? UIImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        self.navigationController?.navigationBarHidden = true
        btn_continue.layer.borderColor = UIColor(rgba:"#D1D3D4").CGColor
        btn_continue.layer.borderWidth = 1.0
        btn_continue.layer.cornerRadius = 5.0
        
    }

    @IBAction func addPhoto(sender: AnyObject) {
    }

    @IBAction func SavePhotoAndContinue(sender: AnyObject) {
        
        if(txt_name_home.text!.isEmpty){
            let presenter2 = Presentr(presentationType: .Alert)
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.lbl_mensaje.text = "Debe ingresar el nombre de un lugar"
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
