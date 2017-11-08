//
//  HueViewController.swift
//  Living
//
//  Created by Nelson FB on 26/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import SwiftHUEColorPicker
import DZNEmptyDataSet
import Presentr
import SwiftyTimer
import UIColor_Hex_Swift


class HueViewController: UIViewController,UITabBarDelegate, HueEndpointCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {

    enum HueListType {
        case groups
        case lights

    }

    var endpoint:Endpoint?
    var selectedLight:HueLight?
    var selectedGroup:HueGroup?
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var hue:Hue?;
    var type = HueListType.groups
    let theme:ThemeManager = ThemeManager()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var buttonLeft: VKExpandableButton!
    @IBOutlet weak var colorPicker: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endpoint = ArSmartApi.sharedApi.SelectedEndpoint
        hue = Hue()
        hue!.endpoint = self.endpoint!
        
        
        
        let nib = UINib(nibName: "HueEndpointCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "menuCell")
        self.tableView.addSubview(self.refreshControl)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        tabBar.selectedItem = tabBar.items![0]
        


        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        self.title = "Hue Manager"
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.after(500.ms) { 
            
        
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            presenter2.dismissOnTap = false
            let vc = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc, animated: true, completion: nil)
            vc.setText( "Un momento por favor...")
            self.getHueInfo()

        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHueInfo(){
    
        //hue?.RequestHueInfo_Test(token, hub: hub!, completion: { (IsError, result) in
        hue?.RequestHueInfo(token, hub: hub!, completion: { (IsError, result) in
            
            
            if(IsError){
                print("Error",result)
            }else{
                 print("Success",result)
                self.tableView.reloadData()
            }
            self.dismiss(animated: true, completion: {})
        })
    
    }
    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        self.view.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.color:

            break
        default:
            break

        }
    }
    
    func tableView(_ tableView: UITableView!, titleForHeaderInSection section: Int) -> String!{
        if type == .groups{
            return self.hue?.groupName(section)
        }else{
            return "Luces individuales"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == .groups{
            return (self.hue?.groupLightsCount(section))!
        }else{
            return (self.hue?.lights.count)!
        }
        

      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! HueEndpointCell
        
        if type == .groups{
            //cell.light = self.hue?.groups[indexPath.section].lights[indexPath.row]
            cell.setLight((self.hue?.groups[(indexPath as NSIndexPath).section].lights[(indexPath as NSIndexPath).row])!)
            let group = self.hue?.groups[(indexPath as NSIndexPath).section].lights[(indexPath as NSIndexPath).row]
            cell.lbl_hue?.text = group!.name
        }else{
            cell.setLight((self.hue?.lights[(indexPath as NSIndexPath).row])!)
            //cell.light = self.hue?.lights[indexPath.row]
            let light = self.hue?.lights[(indexPath as NSIndexPath).row]
            cell.lbl_hue?.text = light!.name
        }
        
        cell.delegate = self
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        

    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //This method will be called when user changes tab.
        
        if(item.title == "Grupos"){
            type = .groups
        }else{
        
            type = .lights
        }
        tableView.reloadData()
    }
    
    
    //Delegate HueEndpointCellDelegate
    func ShowColorPicker(_ light:HueLight){
        selectedLight = light
        self.performSegue(withIdentifier: "ShowColorPicker", sender: light)
        
    }
    func ToggleLight(_ light:HueLight){
        
        selectedLight = light
    
    }
    func ShowColorPicker_Group(_ group:HueGroup){
    
    }
    func ToggleLight_Group(_ group:HueGroup){

        self.performSegue(withIdentifier: "ShowColorPicker", sender: group)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ShowColorPicker") {
            // pass data to next view
            let destinationVC = segue.destination as! HueColorViewController
            destinationVC.hueLight = selectedLight
            destinationVC.endpoint = self.endpoint

            
        }
    }
    @IBAction func CloseHueView(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    

    func handleRefresh(_ refreshControl: UIRefreshControl) {

        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Hue"
let attrs = [NSAttributedStringKey.underlineStyle.rawValue : 1,NSAttributedStringKey.foregroundColor : UIColor.white] as [AnyHashable : Any]
        return NSAttributedString(string: str, attributes: attrs as! [NSAttributedStringKey : Any])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay items registrados"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
