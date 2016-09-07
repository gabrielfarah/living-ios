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

class HomeViewController:UIViewController,SideMenuControllerDelegate, MainMenuHeaderViewDelegate{


    
    
    enum HomeViewControllerSectionType {
        case Endpoints, Scenes, Rooms
    }

    
    
    @IBOutlet weak var endpoints_list: UICollectionView!
    @IBOutlet weak var view_new_endpoints: UIView!
    
    
    
    /* Class Variables*/
    let reuseIdentifier = "collectionmainmenucell" // also enter this string as the cell identifier in the storyboard
    var theme = ThemeManager()
    var endpoints:NSMutableArray! // <-- Array to hold the fetched images
    var totalEndpointsCountNeeded:Int! // <-- The number of images to fetch
    var timer_status:NSTimer = NSTimer()
    var can_get_status:Bool = false
    var view_type:HomeViewControllerSectionType = HomeViewControllerSectionType.Endpoints
    var rooms:Rooms = Rooms()
    var menuView:BTNavigationDropdownMenu!;
    var selectedEndpointIndex:Int = 0
    
    let token = ArSmartApi.sharedApi.getToken()
    var hub = ArSmartApi.sharedApi.hub?.hid
    var navController:UINavigationController!
    
    var scenes:Scenes = Scenes()
    
    private var layout : CSStickyHeaderFlowLayout? {
        return self.endpoints_list?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Hubs", items: []);
        
        sideMenuController?.delegate = self
        view_new_endpoints.hidden = true
        
        let image = UIImage(named: "xbox_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationItem.rightBarButtonItem  = UIBarButtonItem(image:image , style: .Plain, target: self, action:#selector(showNotifications))
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:theme.MainColor)
        navController = self.navigationController
        
        style();
        
        // Notifications Registration
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoadEndpoints), name:"LoadEndpoints", object: nil)
        let nib = UINib(nibName: "EndPointMenuCell", bundle: nil)
        self.endpoints_list.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)


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
        NSTimer.after(5.0.seconds) {
            self.GetDevicesStatus()
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
        sideMenuController?.performSegueWithIdentifier("ShowActionsView", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        let navigationBarAppereance = UINavigationBar.appearance()
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
        
        if(view_type == HomeViewControllerSectionType.Endpoints){
            return (ArSmartApi.sharedApi.hub?.endpoints.count())!
        }else if(view_type == HomeViewControllerSectionType.Rooms){
            return rooms.rooms.count
        }else{
            return (scenes.scenes.count)
        }
        

    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if(view_type == HomeViewControllerSectionType.Endpoints){
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EndPointMenuCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            let image = UIImage(named:endpoint.ImageNamed())!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.setStatus(endpoint)
            let endpoint_name = String(format:"%@ %d %@",endpoint.name,endpoint.node, endpoint.getEndpointTypeString())
            cell.setGalleryItem(image, text: endpoint_name)

        
            return cell
        }else if(view_type == HomeViewControllerSectionType.Rooms){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EndPointMenuCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let room = rooms.rooms[indexPath.item]
            
            let image = UIImage(named:"lamp_icon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.setGalleryItem(image, text: room.description)
            return cell
        }else{
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EndPointMenuCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let scene = scenes.scenes[indexPath.item]
            
            let image = UIImage(named:"lamp_icon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.setGalleryItem(image, text: scene.name)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        selectedEndpointIndex = indexPath.item
        if(view_type == HomeViewControllerSectionType.Endpoints){
            

            let endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EndPointMenuCell
            
            cell.setStatus(endpoint)
            
            print(endpoint.ui_class_command)

            ShowEndpointController(endpoint)
            
        }else if(view_type == HomeViewControllerSectionType.Rooms){
            
            let room = rooms.rooms[indexPath.row]
            
            print("Room:",room.description)
        }else{

            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EndPointMenuCell
            cell.setColor(UIColor.redColor())
            
            

            
            
            let scene = scenes.scenes[indexPath.row]
            
            scene.run(token, hub: hub!, completion: { (IsError, result) in
                if(!IsError){

                    
                    
                }else{
                    

                }
            })
        }
        

        
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "parallaxHeader", forIndexPath: indexPath) as! CollectionParallaxHeader
        
            view.imageView?.delegate = self
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
        
        
        menuView = BTNavigationDropdownMenu(navigationController: navController, containerView: navController!.view, title: "Hubs", items: items)
        menuView.menuTitleColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = UIColor.whiteColor()
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            ArSmartApi.sharedApi.hub = ArSmartApi.sharedApi.hubs.hubs[indexPath]
            self!.hub = ArSmartApi.sharedApi.hub?.hid
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
                vc.endpoint = endpoint
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
                vc.endpoint = endpoint
                customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                break
            case "ui-hue":
                /*let width = ModalSize.Custom(size: 300)
                let height = ModalSize.Custom(size: 450)
                let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                let vc = HueViewController(nibName: "HueViewController", bundle: nil)
                vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)*/
                self.performSegueWithIdentifier("ShowHueController", sender: nil)

                break
            case "ui-sensor-motion-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint

                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break

            default:
                let width = ModalSize.Custom(size: 240)
                let height = ModalSize.Custom(size: 433)
                let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                
                presenter.transitionType = .CrossDissolve // Optional
                presenter.dismissOnTap = true
                let vc = SensorViewController(nibName: "SensorViewController", bundle: nil)
                 vc.endpoint = endpoint

                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
        
        
        }
        



    
    }
    

    
    
    func GetDevicesStatus(){

        
        if(can_get_status){

            ArSmartApi.sharedApi.hub?.endpoints.GetStatusZWavesDevicesTask(hub!, token: token, completion: { (IsError, result) in
                
                NSTimer.after(5.0.seconds) {
                    self.GetDevicesStatus()
                }
                
                if(!IsError){
                    print(result)
                    if(result == "processing" || result == ""){}
                }else{
                    //TODO: Que pasa cuando se hace la consulta correctamente, vamos a mmapear los valores de esa respuesta.
                    self.endpoints_list.reloadData()
                }
            })
        }
    
    }
    
    //MainMenuHeaderViewDelegate Methods
    func MenuRoomsSelected() {
        print("Room selected")
        can_get_status = false
        rooms.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(IsError){
                
                
            }else{
                self.view_type = HomeViewControllerSectionType.Rooms
                self.endpoints_list.reloadData()
            }
        }
        

        
        
    }
    func MenuDevicesSelected() {
        can_get_status = true
        GetDevicesStatus()
        print("Devices selected")
        view_type = HomeViewControllerSectionType.Endpoints
        self.endpoints_list.reloadData()
    }
    func MenuFavoriteSelected() {
        can_get_status = false
        print("Favorites selected")
        
        
        scenes.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(IsError){
            }else{
                self.view_type = HomeViewControllerSectionType.Scenes
                self.endpoints_list.reloadData()
            }
        }
        
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "ShowHueController"){
            let destinationVC = segue.destinationViewController as! UINavigationController
            let root = destinationVC.viewControllers[0] as! HueViewController
            
            
            root.endpoint = ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(selectedEndpointIndex)
        
        }
        
     }
 
    
}