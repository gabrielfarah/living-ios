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

class RoomsViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var rooms = Rooms()
    var selected_room = Room()
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
         self.tableView.addSubview(self.refreshControl)
        load_rooms()

        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        self.title = "Rooms"
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:NSNotification.Name(rawValue: "AddRoomError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:NSNotification.Name(rawValue: "AddRoomSuccess"), object: nil)
        
    }
    func methodOfReceivedNotificationError(_ notification: Notification){
        //Take Action on Notification

        
        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 80)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        
        vc2.setText("Error en la operación , por favor vuelva a intentarlo")
        
        
    }
    func methodOfReceivedNotificationSuccess(_ notification: Notification){
        //Take Action on Notification
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 80)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.setText("Se adicionó cuarto con éxito")
        

        load_rooms()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGuest(_ sender: AnyObject) {
        
        let width = ModalSize.custom(size: 280)
        let height = ModalSize.custom(size: 132)
        let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.topCenter))
        //presenter.backgroundOpacity = 0.1
        presenter.blurBackground = true
        presenter.dismissOnTap = true
        
        
        presenter.transitionType = .crossDissolve // Optional
        let vc2 = AddRoomViewController(nibName: "AddRoomViewController", bundle: nil)
        self.customPresentViewController(presenter, viewController: vc2, animated: true, completion: nil)
        vc2.txt_email.becomeFirstResponder()
        
        

        
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.rooms.rooms[(indexPath as NSIndexPath).row].description
        
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
            self.navigationController?.popViewController(animated: true)
            
            
        }else{
        
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let presenter: Presentr = {
            let presenter = Presentr(presentationType: .alert)
            presenter.transitionType = TransitionType.crossDissolve
            return presenter
            }()
            
            

            let title = "Está seguro?"
            let body = "No se puede deshacer esta acción"
            
            let controller = Presentr.alertViewController(title: title, body: body)

            
            let deleteAction = AlertAction(title: "Estoy seguro", style: .destructive) {
                print("Deleted!")
                // Delete the row from the data source
                let token = ArSmartApi.sharedApi.getToken()
                let hub = ArSmartApi.sharedApi.hub?.hid
                
                let room = self.rooms.rooms[(indexPath as NSIndexPath).row]
                room.delete(token, hub: hub!, completion: { (IsError, result) in
                    self.load_rooms()
                    
                    Timer.after(500.milliseconds) {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 80)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        vc2.setText("El cuarto ha sido eliminado")
                    }
                    
                    

                })
            }
            
            let okAction = AlertAction(title: "Cancelar", style: .cancel){
                print("Ok!")
            }
            
            controller.addAction(deleteAction)
            controller.addAction(okAction)
            
            presenter.presentationType = .alert
            customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
            
            

            
            
            
        }
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Rooms"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay cuartos registrados"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = "New room"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        
        
        self.AddGuest(self)
    }
    
    
}
