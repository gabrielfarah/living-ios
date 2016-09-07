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

class HueViewController: UIViewController, SwiftHUEColorPickerDelegate,UITabBarDelegate  {

    
    var endpoint:Endpoint?
    
    let token = ArSmartApi.sharedApi.getToken()
    let hub = ArSmartApi.sharedApi.hub?.hid
    var hue:Hue?;
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var buttonLeft: VKExpandableButton!
    @IBOutlet weak var colorPicker: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hue = Hue()
        hue!.endpoint = self.endpoint!
        
        getHueInfo()
        
        // Do any additional setup after loading the view.
        
        self.buttonLeft.direction      = .Right
        self.buttonLeft.options        = ["Off", "On"]
        self.buttonLeft.currentValue   = self.buttonLeft.options[0]
        self.buttonLeft.cornerRadius   = self.buttonLeft.frame.size.height / 2
        
        self.buttonLeft.optionSelectionBlock = {
            index in
            print("[Right] Did select option at index: \(index)")
        }
        
        
        //colorPicker.delegate = self
        //colorPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        //colorPicker.type = SwiftHUEColorPicker.PickerType.Color
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHueInfo(){
    
        hue?.RequestHueInfo(token, hub: hub!, completion: { (IsError, result) in
            if(IsError){
                print("Error",result)
            }else{
                 print("Success",result)
                self.tableView.reloadData()
            }
        })
    
    }
    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        self.view.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.Color:

            break
        default:
            break

        }
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!{
        if(self.hue?.groups.count>0){
            return (self.hue?.groups[section].name)!
        }else{
            return ""
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.hue?.groups.count>0){
            return (self.hue?.groups[section].lights.count)!
        }else{
            return 0
        }
        

      
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        let group = self.hue?.groups[indexPath.section].lights[indexPath.row]
        
        cell.textLabel?.text = group!.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //This method will be called when user changes tab.
        
        if(item.title == "Grupos"){}else{}
    }
    
}
