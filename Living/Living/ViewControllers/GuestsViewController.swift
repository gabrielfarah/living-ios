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

class GuestsViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    

    var theme = ThemeManager()
    var items = [String]()
    var guests = Guests()
    
    
    @IBOutlet weak var empty_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_add_guest: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        // Do any additional setup after loading the view.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        load_guests()
        
        if (self.guests.guests.count>0){
            self.tableView.hidden = false
            self.empty_view.hidden = true
        }else{
            self.tableView.hidden = true
            self.empty_view.hidden = false
        }
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:theme.MainColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Invitados"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:"AddGuestError", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:"AddGuestSuccess", object: nil)
        
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
        
        let presenter2 = Presentr(presentationType: .Alert)
        
        
        presenter2.transitionType = .CrossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.lbl_mensaje.text = "Se adicionó el usuario con éxito"
        load_guests()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGuest(sender: AnyObject) {
        
        let width = ModalSize.Custom(size: 280)
        let height = ModalSize.Custom(size: 132)
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.TopCenter))
        //presenter.backgroundOpacity = 0.1
        presenter.blurBackground = true
        presenter.dismissOnTap = true

        
        presenter.transitionType = .CrossDissolve // Optional
        let vc2 = AddGuestViewController(nibName: "AddGuestViewController", bundle: nil)
        self.customPresentViewController(presenter, viewController: vc2, animated: true, completion: nil)
        vc2.txt_email.becomeFirstResponder()
        
        
        //vc2.lbl_mensaje.text = "Test"
        
        
    }

    
    func load_guests(){
    
        guests.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()
                if (self.guests.guests.count>0){
                    self.tableView.hidden = false
                    self.empty_view.hidden = true
                }else{
                    self.tableView.hidden = true
                    self.empty_view.hidden = false
                }

            }
        }
    
    
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
        return self.guests.guests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.guests.guests[indexPath.row].email
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

    }

}
