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
import UIColor_Hex_Swift

class HomeViewController:UIViewController,SideMenuControllerDelegate, MainMenuHeaderViewDelegate,SensorViewControllerDelegate{

    static let LoadEndpoints = Notification.Name("LoadEndpoints")
    
    
    enum HomeViewControllerSectionType {
        case endpoints, scenes, rooms
    }

    
    
    @IBOutlet weak var endpoints_list: UICollectionView!
    @IBOutlet weak var view_new_endpoints: UIView!
    
    var room_name = ""
    
    /* Class Variables*/
    let reuseIdentifier = "collectionmainmenucell" // also enter this string as the cell identifier in the storyboard
    var theme = ThemeManager()
    var endpoints:NSMutableArray! // <-- Array to hold the fetched images
    var totalEndpointsCountNeeded:Int! // <-- The number of images to fetch
    var timer_status:Timer = Timer()
    var can_get_status:Bool = false
    var view_type:HomeViewControllerSectionType = HomeViewControllerSectionType.scenes
    var rooms:Rooms = Rooms()
    var menuView:BTNavigationDropdownMenu!;
    var selectedEndpointIndex:Int = 0
    
    let token = ArSmartApi.sharedApi.getToken()
    var hub = ArSmartApi.sharedApi.hub?.hid
    var navController:UINavigationController!
    var presenter2:Presentr?
    var scenes:Scenes = Scenes()
    
    var selectedRoom:Room = Room()
    
    fileprivate var layout : CSStickyHeaderFlowLayout? {
        return self.endpoints_list?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Hubs", items: []);
        
        sideMenuController?.delegate = self
        view_new_endpoints.isHidden = true
        
        let image = UIImage(named: "xbox_menu")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        navigationItem.rightBarButtonItem  = UIBarButtonItem(image:image , style: .plain, target: self, action:#selector(showNotifications))
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        navController = self.navigationController
        
        style();
        
        // Notifications Registration
        NotificationCenter.default.addObserver(self, selector: #selector(LoadEndpoints), name:NSNotification.Name(rawValue: "LoadEndpoints"), object: nil)
        let nib = UINib(nibName: "EndPointMenuCell", bundle: nil)
        self.endpoints_list.register(nib, forCellWithReuseIdentifier: reuseIdentifier)


        self.endpoints_list?.register(CollectionParallaxHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "parallaxHeader")
        self.layout?.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 102)

        

        self.endpoints_list!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture)))
        

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        can_get_status = true
    
        Timer.every(100.ms) { (timer: Timer) in

        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        self.presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        self.presenter2!.transitionType = .crossDissolve // Optional
        self.presenter2!.dismissOnTap = false
        let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        self.customPresentViewController(self.presenter2!, viewController: vc, animated: true, completion: nil)
        vc.setText( "Un momento por favor...")
        
            
        //TODO: Actualizar el token aqui....
            
            

            
            self.init_load()
         
        
        timer.invalidate()
            
        }
        
       
        
 

    }

    
    func init_load(){
        
        
        self.scenes.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(IsError){
            }else{
                
            }

            ArSmartApi.sharedApi.hubs.load(ArSmartApi.sharedApi.getToken(),completion: { (IsError, result) in
                
                
                self.rooms.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
                    if(IsError){
                        //TODO: Manejo de errores
                        
                    }else{
                        
                    }
                    
                    self.dismiss(animated: true, completion: {
                        
                    })
                }
                
                
                
                ArSmartApi.sharedApi.syncHub()
                
                if ArSmartApi.sharedApi.hub!.hid == 0 {
                    
                    Timer.after(1.0.seconds) {
                        
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 243)
                        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter.transitionType = .crossDissolve // Optional
                        presenter.dismissOnTap = false
                        let vc = SelectDeviceViewController(nibName: "SelectDeviceViewController", bundle: nil)
                        self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                        
                    }
                    
                }else{
                    
                    NotificationCenter.default.post(name:HomeViewController.LoadEndpoints, object: nil)
                }
                
            })
            
            
            
   
        }
        
    
        
    
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        can_get_status = false
    }
    
    func fetchEndPoints () {
        endpoints = NSMutableArray()
        totalEndpointsCountNeeded = 10

    }
    
    @IBAction func showNotifications() {
        sideMenuController?.performSegue(withIdentifier: "ShowActionsView", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        let navigationBarAppereance = UINavigationBar.appearance()
        navigationBarAppereance.tintColor = UIColor.white

        
    }
    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    

    // MARK: WaterfallLayoutDelegate
    
    // tell the collection view how many cells to make
    
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.endpoints_list.indexPathForItem(at: gesture.location(in: self.endpoints_list)) else {
                break
            }
            endpoints_list.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            endpoints_list.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            endpoints_list.endInteractiveMovement()
        default:
            endpoints_list.cancelInteractiveMovement()
        }
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        
        
        // handle tap events
        print("You selected cell #\((indexPath as NSIndexPath).item)!")
        
        selectedEndpointIndex = (indexPath as NSIndexPath).item
        if(view_type == HomeViewControllerSectionType.endpoints){
            
            var endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            

            if selectedRoom.rid != 0 {
                let endpoints_temp = ArSmartApi.sharedApi.hub?.endpoints.inRoom(room: selectedRoom)
                endpoint = (endpoints_temp?[indexPath.row])!
            }
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EndPointMenuCell
            if(endpoint.ui_class_command == "ui-binary-light-zwave"){
                cell.setColor(UIColor.red)
            }
            
            
            
            cell.setStatus(endpoint)
            print(endpoint.ui_class_command)
            ShowEndpointController(endpoint)
            
        }else if(view_type == HomeViewControllerSectionType.rooms){
            
            let room = rooms.rooms[(indexPath as NSIndexPath).row]
            selectedRoom = room
            print("Room:",room.description)
            //TODO: Filtrar por cuartos
            self.room_name = room.description
            RoomSelected()
            
        }else{

            let cell = collectionView.cellForItem(at: indexPath) as! EndPointMenuCell
            cell.setColor(UIColor.red)
            let scene = scenes.scenes[(indexPath as NSIndexPath).row]
            scene.run(token, hub: hub!, completion: { (IsError, result) in
                if(!IsError){

                    
                    
                }else{
                    

                }
            })
        }
        

        
    }



    func LoadEndpoints(_ notification: Notification){
        
        
        
        
        var items = [String]()
        
        for hub:Hub in ArSmartApi.sharedApi.hubs.hubs{
            items.append(hub.name)
            
        }
        
        
        menuView = BTNavigationDropdownMenu(navigationController: navController, containerView: navController!.view, title:  ArSmartApi.sharedApi.hub!.name, items: items as [AnyObject])
        menuView.menuTitleColor = UIColor.white
        menuView.cellTextLabelColor = UIColor.white
        self.navigationItem.titleView = menuView
        

        
        
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            ArSmartApi.sharedApi.setHub(ArSmartApi.sharedApi.hubs.hubs[indexPath])
            
            self!.hub = ArSmartApi.sharedApi.hub?.hid
            self!.endpoints_list.reloadData()
            self!.GetDevicesStatus()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoadEndpoints"), object: nil)

        }
        
    
        if((ArSmartApi.sharedApi.hub?.endpoints.count())!>0){
            view_new_endpoints.isHidden = true
            endpoints_list.isHidden = false
        }else{

            view_new_endpoints.isHidden = false
            endpoints_list.isHidden = true
        
        }
        


        //GetDevicesStatus()
        
        self.endpoints_list.reloadData()
        
    }
    
    func ShowEndpointController(_ endpoint:Endpoint){
    
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter.transitionType = .crossDissolve // Optional
        presenter.dismissOnTap = true
        
        
        
        switch(endpoint.ui_class_command){

            case "ui-binary-outlet-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint
                
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)

                break
            case "ui-binary-light-zwave":
                //let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 //vc.endpoint = endpoint
                
                //customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                
                //TODO hacer directamente el boton
                hub = ArSmartApi.sharedApi.hub?.hid
                let value = ( endpoint.state > 0 ) ? 0 : 255;
                endpoint.state = value
                endpoints_list.reloadData()
                endpoint.setValue(hub!, token: token, value: String(value)) { (IsError, result) in
                    print("Change Value")
                    if(IsError){
                        print("Set Command Error")
                    }else{
                        print("Set Command Success")
                    }
                }

                break
            case "ui-level-light-zwave":
                let height2 = ModalSize.custom(size: 369)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height2, center:ModalCenterPosition.center))
                let vc = LevelViewController(nibName: "LevelViewController", bundle: nil)
                vc.endpoint = endpoint
                
                customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                //vc.slider_level.setValue(Float(endpoint.state), animated: false)
                
                vc.lbl_name.text = endpoint.name
                break
            case "ui-sensor-open-close-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint

                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                vc.lbl_name.text = endpoint.name
                break
            case "ui-lock-zwave":
                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                 vc.endpoint = endpoint

                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                vc.lbl_name.text = endpoint.name
                break
            
            case "ui-switch-multilevel-zwave":
                //let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                //vc.endpoint = endpoint
                //customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                let height2 = ModalSize.custom(size: 369)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height2, center:ModalCenterPosition.center))
                let vc = LevelViewController(nibName: "LevelViewController", bundle: nil)
                vc.endpoint = endpoint
                
                customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
                vc.lbl_name.text = endpoint.name
                //vc.slider_level.setValue(Float(endpoint.state), animated: false)
                break
                
                

            
            case "ui-sonos":
                let height2 = ModalSize.custom(size: 195)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height2, center:ModalCenterPosition.center))
            
                presenter2.transitionType = .crossDissolve // Optional
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
                //self.performSegueWithIdentifier("ShowHueController", sender: nil)
                let endpoint = ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(selectedEndpointIndex)
                ArSmartApi.sharedApi.SelectedEndpoint = endpoint
                sideMenuController?.performSegue(withIdentifier: "ShowHueView", sender: nil)
                
                

                break
            case "ui-sensor-motion-zwave":

                let vc = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
                vc.endpoint = endpoint
                customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
                break
            
            
            case "ui-sensor-binary-zwave":
            
               /* let width = ModalSize.custom(size: 300)
                let height = ModalSize.custom(size: 452)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                let vc = SensorViewController(nibName: "SensorViewController", bundle: nil)
                vc.endpoint = endpoint
                customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)*/
                
                //TODO: Se deja para la siguiente version.
                
                break

            default:
                hub = ArSmartApi.sharedApi.hub?.hid
                let value = ( endpoint.state > 0 ) ? 0 : 255;
                endpoint.state = value
                endpoints_list.reloadData()
                endpoint.setValue(hub!, token: token, value: String(value)) { (IsError, result) in
                    print("Change Value")
                    if(IsError){
                        print("Set Command Error")
                    }else{
                        print("Set Command Success")
                    }
                }
                
                break
        
        
        }

    }
    

    
    
    func GetDevicesStatus(){

        
        if(can_get_status && view_type == HomeViewControllerSectionType.endpoints ){

            ArSmartApi.sharedApi.hub?.endpoints.GetStatusZWavesDevicesTask(hub!, token: token, completion: { (IsError, result) in
                
                Timer.after(10.0.seconds) {
                    self.GetDevicesStatus()
                }
                
                if(!IsError){
                    print(result)
                    if(result == "processing" || result == ""){
                        
                        

                            // Bounce back to the main thread to update the UI
                            DispatchQueue.main.async {
                                self.endpoints_list.reloadData()
                            }
                        
                        
                        
             
                    }
                }else{
                    //TODO: Que pasa cuando se hace la consulta correctamente, vamos a mmapear los valores de esa respuesta.

                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            self.endpoints_list.reloadData()
                        }
                    
                }
            })
        }
    
    }
    
    //MainMenuHeaderViewDelegate Methods
    func MenuRoomsSelected() {
        print("Room selected")
        can_get_status = false
        
        self.view_type = HomeViewControllerSectionType.rooms
        self.endpoints_list.reloadData()

        

        
        
    }
    func MenuDevicesSelected() {
        can_get_status = true
        
        print("Devices selected")
        view_type = HomeViewControllerSectionType.endpoints
       self.view_new_endpoints.clearsContextBeforeDrawing = true
        self.endpoints_list.reloadData()
        

        selectedRoom = Room()
        room_name = ""
        //GetDevicesStatus()
    }
    
    // Esta funcion permite mostrar los devices d
    func RoomSelected() {
        can_get_status = true
        view_type = HomeViewControllerSectionType.endpoints
        self.endpoints_list.reloadData()
        
        

        
    }
    func MenuFavoriteSelected() {
        can_get_status = false
        print("Favorites selected")
         room_name = ""
        self.view_type = HomeViewControllerSectionType.scenes
        self.endpoints_list.reloadData()
        

        
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "ShowHueController"){
            let destinationVC = segue.destination as! UINavigationController
            let root = destinationVC.viewControllers[0] as! HueViewController
            
            let endpoint = ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(selectedEndpointIndex)
            root.endpoint = endpoint
        
        }
        
     }
    //SensorViewControllerDelegate Methods
    
    func SensorViewControllerDone(_ IsError: Bool, Result: String) {
        self.dismiss(animated: true) { 
            Timer.after(500.milliseconds) {
            
                let width = ModalSize.custom(size: 240)
                let height = ModalSize.custom(size: 80)
                let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                
                presenter2.transitionType = .crossDissolve // Optional
                let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                
                vc2.setText(Result)
            
            }
        }
    }
    

    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(view_type == HomeViewControllerSectionType.endpoints){
            
            if(selectedRoom.rid == 0){
                return (ArSmartApi.sharedApi.hub?.endpoints.count())!
            }else{
                let endpoints_temp = ArSmartApi.sharedApi.hub?.endpoints.inRoom(room: selectedRoom)
                return endpoints_temp!.count
            }
            
            
            
            
        }else if(view_type == HomeViewControllerSectionType.rooms){
            return rooms.rooms.count
        }else{
            return (scenes.scenes.count)
        }
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("MOVING!")
        if(view_type == HomeViewControllerSectionType.endpoints){
            
            
            //var endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            //TODO: Aqui se cambian, probablemente se deberia actualizar el orden aqui mismo.
            let temp = ArSmartApi.sharedApi.hub?.endpoints.endpoints.remove(at: sourceIndexPath.item)
            ArSmartApi.sharedApi.hub?.endpoints.endpoints.insert(temp!, at: destinationIndexPath.item)
            
           
            
        
            ArSmartApi.sharedApi.hub?.endpoints.saveEndpointsSort(ArSmartApi.sharedApi.hub!.hid, token: ArSmartApi.sharedApi.getToken(), completion: { (IsError, response) in
                
            })
            
        }else if (view_type == HomeViewControllerSectionType.rooms){
            
            
            //var endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            //TODO: Aqui se cambian, probablemente se deberia actualizar el orden aqui mismo.
            let temp = rooms.rooms.remove(at: sourceIndexPath.item)
            rooms.rooms.insert(temp, at: destinationIndexPath.item)
            
            
            
            
            rooms.saveSort(ArSmartApi.sharedApi.hub!.hid, token: ArSmartApi.sharedApi.getToken(), completion: { (IsError, response) in
                
            })
            
        }else if (view_type == HomeViewControllerSectionType.scenes){
            
            
            //var endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            //TODO: Aqui se cambian, probablemente se deberia actualizar el orden aqui mismo.
            let temp = scenes.scenes.remove(at: sourceIndexPath.item)
            scenes.scenes.insert(temp, at: destinationIndexPath.item)
            
            
            
            
            scenes.saveSort(ArSmartApi.sharedApi.hub!.hid, token: ArSmartApi.sharedApi.getToken(), completion: { (IsError, response) in
                
            })
            
        }
        
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(view_type == HomeViewControllerSectionType.endpoints){
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EndPointMenuCell
            
            //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EndPointMenuCell
            
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            
            var endpoint = (ArSmartApi.sharedApi.hub?.endpoints.objectAtIndex(indexPath.item))!
            if selectedRoom.rid != 0{
                let endpoints_temp = ArSmartApi.sharedApi.hub?.endpoints.inRoom(room: selectedRoom)
                endpoint = (endpoints_temp?[indexPath.row])!
            }
            
            
            let image = UIImage(named:endpoint.ImageNamed())!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.setStatus(endpoint)
            let endpoint_name = String(format:"%@ ",endpoint.name)
            cell.setGalleryItem(image, text: endpoint_name)
            cell.isEndpoint = true
            
            cell.itemImageView.layer.removeAllAnimations()
            return cell
        }else if(view_type == HomeViewControllerSectionType.rooms){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EndPointMenuCell
            cell.isEndpoint = false
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let room = rooms.rooms[(indexPath as NSIndexPath).item]
            
            let image = UIImage(named:"lamp_icon")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.setGalleryItemNoStatus(image, text: room.description)
            cell.setHeaderColor(color: room.color)
            cell.itemImageView.layer.removeAllAnimations()
            
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EndPointMenuCell
             cell.isEndpoint = false
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            let scene = scenes.scenes[(indexPath as NSIndexPath).item]
            
            let image = UIImage(named:"lamp_icon")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.setGalleryItemNoStatus(image, text: scene.name)
            cell.setHeaderColor(real_color: UIColor.clear)
            cell.itemImageView.layer.removeAllAnimations()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "parallaxHeader", for: indexPath) as! CollectionParallaxHeader
        
        view.imageView?.delegate = self
        view.imageView?.lbl_room_name.text = self.room_name
        return view
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        // Set some extra pixels for height due to the margins of the header section.
        //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 16 worked for me as I have 8px for top and bottom constraints.
        return CGSize(width: collectionView.frame.width, height: 113)
    }
    
}
