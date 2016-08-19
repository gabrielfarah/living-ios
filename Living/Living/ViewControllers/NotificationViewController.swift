//
//  NotificationViewController.swift
//  Living
//
//  Created by Nelson FB on 16/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_back: UILabel!
    @IBOutlet weak var empty_view: UIView!
    
    var actions = Actions()
    var theme = ThemeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         if (self.actions.actions.count>0){
            self.tableView.hidden = false
            self.empty_view.hidden = true
        }else{
            self.tableView.hidden = true
            self.empty_view.hidden = false
        }

        load_notifications()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba:theme.MainColor)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Acciones"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func load_notifications(){
        
        actions.load(ArSmartApi.sharedApi.getToken(), hub: ArSmartApi.sharedApi.hub!.hid) { (IsError, result) in
            if(!IsError){
                self.tableView.reloadData()
                if (self.actions.actions.count>0){
                    self.tableView.hidden = false
                    self.empty_view.hidden = true
                }else{
                    self.tableView.hidden = true
                    self.empty_view.hidden = false
                }
                
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.actions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NotificationViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! NotificationViewCell

        cell.lbl_date_text.text = self.actions.actions[indexPath.row].created_at
        cell.lbl_item_text.text = self.actions.actions[indexPath.row].message

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }


}
