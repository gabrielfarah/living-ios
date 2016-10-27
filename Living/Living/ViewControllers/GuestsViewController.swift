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

class GuestsViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {

    

    var theme = ThemeManager()
    var items = [String]()
    var guests = Guests()
    
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
        load_guests()
        

        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Invitados"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:NSNotification.Name(rawValue: "AddGuestError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:NSNotification.Name(rawValue: "AddGuestSuccess"), object: nil)
        
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
        

        
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
        vc2.setText("Se adicionó el usuario con éxito")
        
        load_guests()
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
        let vc2 = AddGuestViewController(nibName: "AddGuestViewController", bundle: nil)
        self.customPresentViewController(presenter, viewController: vc2, animated: true, completion: nil)
        vc2.txt_email.becomeFirstResponder()
        
        
        //vc2.lbl_mensaje.text = "Test"
        
        
    }

    
    func load_guests(){
    
        guests.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
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
        return self.guests.guests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.guests.guests[(indexPath as NSIndexPath).row].email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

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
                
                let guest = self.guests.guests[(indexPath as NSIndexPath).row]
                guest.delete(token, hub: hub!, completion: { (IsError, result) in
                    
                    if(!IsError){
                        self.load_guests()
                        
                        Timer.after(500.milliseconds) {
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.setText("El invitado ha sido removido")
                        }
                    }else{
                       
                        Timer.after(500.milliseconds) {
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.setText("Ocurrió un error el usuario no ha sido borrado")
                        }
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
        let str = "Guest"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay invitados registrados"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = "New Guest"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        
        
        AddGuest(self)
    }

}
