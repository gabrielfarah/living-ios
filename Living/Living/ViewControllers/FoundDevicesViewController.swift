//
//  FoundDevicesViewController.swift
//  Living
//
//  Created by Nelson FB on 2/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import Presentr

class FoundDevicesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_back: UIView!
    
    @IBOutlet weak var lbl_empty: UILabel!
    @IBOutlet weak var lbl_founded: UILabel!
    @IBOutlet weak var view_header: UIView!
    var endpoints:[EndpointResponse] = [EndpointResponse]()
    var selected_endpoint_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // style();
        
         //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if(self.endpoints.count>0){
        
            self.tableView.hidden = false
            self.lbl_empty.hidden = true
            self.lbl_founded.hidden = false
        }else{
            self.tableView.hidden = true
            self.lbl_empty.hidden = false
            self.lbl_founded.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goBack(sender: AnyObject) {
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = endpoints[indexPath.row].name
        cell.detailTextLabel?.text = endpoints[indexPath.row].uid
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selected_endpoint_index = indexPath.row
        self.performSegueWithIdentifier("ShowAddNewDevice", sender: nil)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowAddNewDevice") {
            // pass data to next view
            let destinationVC = segue.destinationViewController as! DeviceEditViewController
            let endpoint = endpoints[selected_endpoint_index].CreateEndpoint()
            destinationVC.endpoint = endpoint
            print("end")
            
        }
    }
    
}
