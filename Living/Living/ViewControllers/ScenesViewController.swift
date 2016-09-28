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

class ScenesViewController: UIViewController,SideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    
    var theme = ThemeManager()
    var items = [String]()
    var scenes = Scenes()
    var selectedScene = 0
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
        
        
        self.title = "Scenes"
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationError), name:NSNotification.Name(rawValue: "AddRoomError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationSuccess), name:NSNotification.Name(rawValue: "AddRoomSuccess"), object: nil)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadScenes()
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
        return self.scenes.scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        

        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = self.scenes.scenes[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedScene = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: "ShowSceneEdit", sender: nil)
        
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
                
                let scene = self.scenes.scenes[(indexPath as NSIndexPath).row]
                scene.delete(token, hub: hub!, completion: { (IsError, result) in
                    
                    if(!IsError){
                        self.loadScenes()
                        
                        Timer.after(500.milliseconds) {
                            let width = ModalSize.custom(size: 240)
                            let height = ModalSize.custom(size: 130)
                            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                            presenter2.transitionType = .crossDissolve // Optional
                            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                            vc2.setText("La escena ha sido eliminada")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "ShowSceneEdit"){
            // Create a variable that you want to send
            let scene = scenes.scenes[selectedScene]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! SceneEditViewController
            destinationVC.scene = scene
            destinationVC.editMode = true
            
        }
        
    }
    
    @IBAction func ShowMenu(_ sender: AnyObject) {
       // NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenu", object: nil)
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
