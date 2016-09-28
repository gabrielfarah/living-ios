//
//  MenuViewController.swift
//  Living
//
//  Created by Nelson FB on 17/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class MenuViewController:UIViewController{
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    let menu_items = MenuItems()
    
    let segues = ["showCenterController1","ShowDevicesView","ShowGuestsView","ShowActionsView","ShowRoomsView","ShowScenesView","ShowMyAccountView"]
    fileprivate var previousIndex: IndexPath?
    
    


    @IBOutlet weak var lbl_menu_item: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu_items.count()
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = menu_items.objectAtIndex((indexPath as NSIndexPath).row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if let index = previousIndex {
            tableView.deselectRow(at: index, animated: true)
        }
        
        sideMenuController?.performSegue(withIdentifier: segues[(indexPath as NSIndexPath).row], sender: nil)
        previousIndex = indexPath
    }
    

}
