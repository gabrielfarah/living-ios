//
//  HomeViewController.swift
//  Living
//
//  Created by Nelson FB on 7/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import UIKit
import SideMenuController
import Presentr
import SwiftyTimer
import CollectionViewWaterfallLayout
import CSStickyHeaderFlowLayout
import BTNavigationDropdownMenu

class HomeViewController:UIViewController,SideMenuControllerDelegate{


    
    @IBOutlet weak var endpoints_list: UICollectionView!
    @IBOutlet weak var view_new_endpoints: UIView!
    
    let reuseIdentifier = "collectionmainmenucell" // also enter this string as the cell identifier in the storyboard
    
    var theme = ThemeManager()
    var endpoints:NSMutableArray! // <-- Array to hold the fetched images
    var totalEndpointsCountNeeded:Int! // <-- The number of images to fetch
    var timer_status:NSTimer = NSTimer()
    var can_get_status:Bool = false
    
    
    
    
    
    private var layout : CSStickyHeaderFlowLayout? {
        return self.endpoints_list?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         sideMenuController?.delegate = self
        view_new_endpoints.hidden = true
        
        let image = UIImage(named: "xbox_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationItem.rightBarButtonItem  = UIBarButtonItem(image:image , style: .Plain, target: self, action:#selector(showNotifications))
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:theme.MainColor)
        
        
        style();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoadEndpoints), name:"LoadEndpoints", object: nil)
        let nib = UINib(nibName: "EndPointMenuCell", bundle: nil)
        self.endpoints_list.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)

        
        // Setup Header
        //self.endpoints_list?.registerClass(CollectionParallaxHeader.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        
        
        self.endpoints_list?.registerClass(CollectionParallaxHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "parallaxHeader")
   
        self.layout?.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 102)

        
        

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        can_get_status = true
    
        if ArSmartApi.sharedApi.hub != nil {
          

            
            var timer = NSTimer.every(500.ms) { (timer: NSTimer) in
                // do something
                
                
                
                let width = ModalSize.Custom(size: 240)
                let height = ModalSize.Custom(size: 243)
                let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                
                presenter.transitionType = .CrossDissolve // Optional
                presenter.dismissOnTap = false
                let vc = SelectDeviceViewController(nibName: "SelectDeviceViewController", bundle: nil)
                self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                
                
                
                timer.invalidate()
                
            }
        
        }

        
        

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        
        can_get_status = false
        
    }
    
    func fetchEndPoints () {
        endpoints = NSMutableArray()
        totalEndpointsCountNeeded = 10

    }
    
    @IBAction func showNotifications() {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        

            var navigationBarAppereance = UINavigationBar.appearance()
        navigationBarAppereance.tintColor = UIColor.whiteColor()

        
    }
    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }
    
    func sideMenuControllerDidHide(sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(sideMenuController: SideMenuController) {
        print(#function)
    }
    
    

    // MARK: WaterfallLayoutDelegate
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (ArSmartApi.sharedApi.hub?.endpoints.count())!
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EndPointMenuCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell

        let endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
        
        let image = UIImage(named:endpoint.ImageNamed())
        
        cell.setGalleryItem(image!, text: endpoint.name)

        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        let endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
        

        // Si no es sensor haga la validación adecuada
        if(!endpoint.isSensor()){
                ShowEndpointController(endpoint)
        }
        
        

        
        
        
        
        /*if(endpoint is Sonos){
        
            let sonos = endpoint as! Sonos
            sonos.GetPlayList()
        
        }*/
        
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "parallaxHeader", forIndexPath: indexPath)
            return view

        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        
        // Set some extra pixels for height due to the margins of the header section.
        //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 16 worked for me as I have 8px for top and bottom constraints.
        return CGSize(width: collectionView.frame.width, height: 113)
    }


    func LoadEndpoints(notification: NSNotification){
        
        
        
        
        var items = [String]()
        
        for hub:Hub in ArSmartApi.sharedApi.hubs.hubs{
            items.append(hub.name)
            
        }
        
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Hubs", items: items)
        menuView.menuTitleColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = UIColor.whiteColor()
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            ArSmartApi.sharedApi.hub = ArSmartApi.sharedApi.hubs.hubs[indexPath]
            self!.endpoints_list.reloadData()
             self!.GetDevicesStatus()

        }
        
    
        if(ArSmartApi.sharedApi.hub?.endpoints.count()>0){
            view_new_endpoints.hidden = true
            endpoints_list.hidden = false
        }else{
            view_new_endpoints.hidden = false
            endpoints_list.hidden = true
        
        }
        


        GetDevicesStatus()
        
        self.endpoints_list.reloadData()
        
    }
    
    func ShowEndpointController(endpoint:Endpoint){
    
        
        let width = ModalSize.Custom(size: 240)
        let height = ModalSize.Custom(size: 130)
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
        
        presenter.transitionType = .CrossDissolve // Optional
        presenter.dismissOnTap = true
        
        
        
        switch(endpoint.ui_class_command){

            case "ui-binary-outlet-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
            case "ui-binary-light-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
            case "ui-level-light-zwave":
                let vc = LevelViewController(nibName: "LevelViewController", bundle: nil)
                
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                vc.lbl_name.text = endpoint.name
                break
            case "ui-sensor-open-close-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
            case "ui-lock-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
            case "ui-sonos":
                let height2 = ModalSize.Custom(size: 195)
                let presenter2 = Presentr(presentationType: .Custom(width: width, height: height2, center:ModalCenterPosition.Center))
                
                presenter2.transitionType = .CrossDissolve // Optional
                presenter2.dismissOnTap = true
                let vc = SonosViewController(nibName: "SonosViewController", bundle: nil)
                customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                break
            case "ui-hue":
                let vc = LevelViewController(nibName: "LevelViewController", bundle: nil)
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                vc.lbl_name.text = endpoint.name
                break
            case "ui-sensor-motion-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break

            default:
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
        
        
        }
        



    
    }
    
    
    
    func GetDevicesStatus(){
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        if(can_get_status){

            ArSmartApi.sharedApi.hub?.endpoints.GetStatusZWavesDevicesTask(hub!, token: token, completion: { (IsError, result) in
                
                if(!IsError){
                    print(result)
                    if(result == "processing" || result == ""){
                        

                        
                        
                    }
                }else{
                    //TODO: Que pasa cuando se hace la consulta correctamente, vamos a mmapear los valores de esa respuesta.
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText(result)
                    

                }
                
                
            })
        }
    
    }
    

}