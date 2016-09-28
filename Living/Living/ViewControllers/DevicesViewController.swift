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

class DevicesViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var rooms = Rooms()
    var selectedEndpoint = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    
    @IBOutlet weak var empty_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_add_guest: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.addSubview(self.refreshControl)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        self.title = "Devices"
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:NSNotification.Name(rawValue: "AddRoomError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:NSNotification.Name(rawValue: "AddRoomSuccess"), object: nil)
        
    }
    func methodOfReceivedNotificationError(_ notification: Notification){
        //Take Action on Notification
        
        let presenter2 = Presentr(presentationType: .alert)
        
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.lbl_mensaje.text = "Error en la operación , por favor vuelva a intentarlo"
    }
    func methodOfReceivedNotificationSuccess(_ notification: Notification){
        //Take Action on Notification
        
        let presenter3 = Presentr(presentationType: .alert)
        
        
        presenter3.transitionType = .crossDissolve // Optional
        let vc3 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter3, viewController: vc3, animated: true, completion: nil)
        vc3.lbl_mensaje.text = "Se adicionó cuarto con éxito"
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return (ArSmartApi.sharedApi.hub?.endpoints.count())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        

        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = ArSmartApi.sharedApi.hub?.endpoints.endpoints[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEndpoint = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: "EditEndpoint", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let token = ArSmartApi.sharedApi.getToken()
            let hub = ArSmartApi.sharedApi.hub?.hid
            ArSmartApi.sharedApi.hub?.endpoints.endpoints[indexPath.row].Delete(hub!, token: token, completion: { (IsError, result) in
                if(!IsError){
                    //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    tableView.reloadData()
                    
                    
                }else{
                }
            })

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "EditEndpoint"){
            // Create a variable that you want to send
            let endpoint = ArSmartApi.sharedApi.hub?.endpoints.endpoints[selectedEndpoint]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! DeviceEditViewController
            destinationVC.endpoint = endpoint!
        
        }

    }
    @IBAction func ShowMenu(_ sender: AnyObject) {
        sideMenuController?.toggle()
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Escenas"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay escenas registradas"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = "New mode"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        
        
        performSegue(withIdentifier: "ShowSceneAdd", sender: nil)
    }
    
}
