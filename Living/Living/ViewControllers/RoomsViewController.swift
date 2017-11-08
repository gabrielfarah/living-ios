//
//  GuestsViewController.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Presentr
import SideMenuController
import DZNEmptyDataSet
import Localize_Swift

class RoomsViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, DeviceCellControllerDelegate, DomuAlertViewControllerDelegate {


    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var rooms = Rooms()
    var selected_room = Room()
    var selected_room_index = 0
    
    
    var is_for_selection = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_add_guest: UIButton!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        // Do any additional setup after loading the view.

         self.tableView.addSubview(self.refreshControl)
        self.tableView.rowHeight = 60.0
        load_rooms()

        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        self.title = "Rooms".localized()
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:NSNotification.Name(rawValue: "AddRoomError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:NSNotification.Name(rawValue: "AddRoomSuccess"), object: nil)
        
        
        
      
    }
    func methodOfReceivedNotificationError(_ notification: Notification){
        //Take Action on Notification

        
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 120)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        
        vc2.setText("Operation failed, please try again...".localized())
        
        
    }
    func methodOfReceivedNotificationSuccess(_ notification: Notification){
        //Take Action on Notification
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 120)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.setText("Room added succesfully...".localized())
        

        load_rooms()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        
//        let width = ModalSize.custom(size: 293)
//        let height = ModalSize.custom(size: 308)
//        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
//        //presenter.backgroundOpacity = 0.1
//        presenter.blurBackground = true
//        presenter.dismissOnTap = false
//        presenter.dismissOnSwipe = true
//        
//        
//        presenter.transitionType = .crossDissolve // Optional
//        let vc2 = AddRoomViewController(nibName: "AddRoomViewController", bundle: nil)
//        self.customPresentViewController(presenter, viewController: vc2, animated: true, completion: nil)
//        vc2.txt_email.becomeFirstResponder()
        
        

        
        
    }
    
    
    func load_rooms(){
        
        rooms.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()

                
            }
        }
        
        
    }
    
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        
        // Create a variable that you want to send

        if segue.identifier == "EditRoom"
        {

            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! AddRoomViewController
            destinationVC.room = selected_room
            destinationVC.forUpdate = true
        }
        
     }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell:DeviceCellController = self.tableView.dequeueReusableCell(withIdentifier: "CellDevice")! as! DeviceCellController
        
        cell.selectedEndpoint = indexPath.row
        cell.lbl_name?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.lbl_name?.text = self.rooms.rooms[(indexPath as NSIndexPath).row].description
        cell.lbl_type?.text = ""
        cell.delegate = self
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(is_for_selection){
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    
                } else {
                    cell.accessoryType = .checkmark
                    
                }
           }
            selected_room = self.rooms.rooms[(indexPath as NSIndexPath).row]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RoomSelected"), object: selected_room)
            _ = self.navigationController?.popViewController(animated: true)
            
            
        }else{
            selected_room = self.rooms.rooms[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "EditRoom", sender: self)
       }
        

        
        
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Rooms".localized()
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "There are no rooms".localized()
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = "New room".localized()
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        
        
        self.AddGuest(self)
    }
    
    func TryDeleteDevice(selectedIndex:Int) {
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        self.selected_room_index = selectedIndex
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = DomuAlertViewController(nibName: "DomuAlertViewController", bundle: nil)
        vc2.delegate = self
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.setText(text: "¿Are you sure you want to delete this room?".localized())
        
    }
    internal func DomuAlert_Cancel() {
        self.dismiss(animated: true) {
        }
    }
    func DomuAlert_OK() {
        
        self.dismiss(animated: true) {

            
            let token = ArSmartApi.sharedApi.getToken()
            let hub = ArSmartApi.sharedApi.hub?.hid
            
            let room = self.rooms.rooms[self.selected_room_index]
            room.delete(token, hub: hub!, completion: { (IsError, result) in
                self.load_rooms()
                
                Timer.after(500.milliseconds) {
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 80)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("The room has been remove succesfully...".localized())
                }
                
                
                
            })
            

        }
        
        
    }
    

    
    
}
