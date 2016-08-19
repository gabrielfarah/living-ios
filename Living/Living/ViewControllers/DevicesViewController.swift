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

class DevicesViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var rooms = Rooms()
    var selectedEndpoint = 0
    
    @IBOutlet weak var empty_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_add_guest: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        // Do any additional setup after loading the view.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        if (ArSmartApi.sharedApi.hub?.endpoints.endpoints.count>0){
            self.tableView.hidden = false
            self.empty_view.hidden = true
        }else{
            self.tableView.hidden = true
            self.empty_view.hidden = false
        }
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        self.title = "Devices"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:"AddRoomError", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:"AddRoomSuccess", object: nil)
        
    }
    func methodOfReceivedNotificationError(notification: NSNotification){
        //Take Action on Notification
        
        let presenter2 = Presentr(presentationType: .Alert)
        
        
        presenter2.transitionType = .CrossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.lbl_mensaje.text = "Error en la operación , por favor vuelva a intentarlo"
    }
    func methodOfReceivedNotificationSuccess(notification: NSNotification){
        //Take Action on Notification
        
        let presenter3 = Presentr(presentationType: .Alert)
        
        
        presenter3.transitionType = .CrossDissolve // Optional
        let vc3 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter3, viewController: vc3, animated: true, completion: nil)
        vc3.lbl_mensaje.text = "Se adicionó cuarto con éxito"
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    
    func sideMenuControllerDidHide(sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(sideMenuController: SideMenuController) {
        print(#function)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ArSmartApi.sharedApi.hub?.endpoints.count())!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        

        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = ArSmartApi.sharedApi.hub?.endpoints.endpoints[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedEndpoint = indexPath.row
        performSegueWithIdentifier("EditEndpoint", sender: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "EditEndpoint"){
            // Create a variable that you want to send
            let endpoint = ArSmartApi.sharedApi.hub?.endpoints.endpoints[selectedEndpoint]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as! DeviceEditViewController
            destinationVC.endpoint = endpoint!
        
        }

    }

    
}
