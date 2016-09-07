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

class ScenesViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var scenes = Scenes()
    var selectedScene = 0
    
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
        
        
        self.title = "Scenes"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:"AddRoomError", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:"AddRoomSuccess", object: nil)
        
        
        loadScenes()
        
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
        return self.scenes.scenes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        

        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.scenes.scenes[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedScene = indexPath.row
        performSegueWithIdentifier("ShowSceneEdit", sender: nil)
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let presenter: Presentr = {
                let presenter = Presentr(presentationType: .Alert)
                presenter.transitionType = TransitionType.CrossDissolve
                return presenter
            }()
            
            
            
            let title = "Está seguro?"
            let body = "No se puede deshacer esta acción"
            
            let controller = Presentr.alertViewController(title: title, body: body)
            
            
            let deleteAction = AlertAction(title: "Estoy seguro", style: .Destructive) {
                print("Deleted!")
                // Delete the row from the data source
                let token = ArSmartApi.sharedApi.getToken()
                let hub = ArSmartApi.sharedApi.hub?.hid
                
                let scene = self.scenes.scenes[indexPath.row]
                scene.delete(token, hub: hub!, completion: { (IsError, result) in
                    
                    if(!IsError){
                        self.loadScenes()
                        
                        NSTimer.after(500.milliseconds) {
                            let width = ModalSize.Custom(size: 240)
                            let height = ModalSize.Custom(size: 130)
                            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                            presenter2.transitionType = .CrossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.setText("La escena ha sido eliminada")
                        }
                    }else{
                        
                        NSTimer.after(500.milliseconds) {
                            let width = ModalSize.Custom(size: 240)
                            let height = ModalSize.Custom(size: 130)
                            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                            presenter2.transitionType = .CrossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.setText("Ocurrió un error el usuario no ha sido borrado")
                        }
                    }
                    
                    
                    
                    
                })
            }
            
            let okAction = AlertAction(title: "Cancelar", style: .Cancel){
                print("Ok!")
            }
            
            controller.addAction(deleteAction)
            controller.addAction(okAction)
            
            presenter.presentationType = .Alert
            customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
            
            
            
            
            
            
        }
    }

    
    func loadScenes(){
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        scenes.load(token, hub: hub!) { (IsError, result) in
            if(IsError){
                //TODO:Manejo de errores
            }else{
                self.tableView.reloadData()
                
            }
        }
    
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "ShowSceneEdit"){
            // Create a variable that you want to send
            let scene = scenes.scenes[selectedScene]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as! SceneEditViewController
            destinationVC.scene = scene
            destinationVC.editMode = true
            
        }
        
    }
    
    @IBAction func ShowMenu(sender: AnyObject) {
       // NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenu", object: nil)
        sideMenuController?.toggle()
    }

    
}
