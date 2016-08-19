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
    private var previousIndex: NSIndexPath?
    
    


    @IBOutlet weak var lbl_menu_item: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu_items.count()
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = menu_items.objectAtIndex(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let index = previousIndex {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
        
        sideMenuController?.performSegueWithIdentifier(segues[indexPath.row], sender: nil)
        previousIndex = indexPath
    }
    

}
