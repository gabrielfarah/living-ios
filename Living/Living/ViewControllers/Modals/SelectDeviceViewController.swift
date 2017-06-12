//
//  SelectDeviceViewController.swift
//  Living
//
//  Created by Nelson FB on 18/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit

class SelectDeviceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        ArSmartApi.sharedApi.hubs.load(ArSmartApi.sharedApi.getToken(),completion: { (IsError, result) in
            self.tableView.reloadData()
        })
        

        tableView.tableFooterView = UIView()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArSmartApi.sharedApi.hubs.hubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = ArSmartApi.sharedApi.hubs.hubs[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none

            } else {
                cell.accessoryType = .checkmark

            }
        }

        
        ArSmartApi.sharedApi.setHub(ArSmartApi.sharedApi.hubs.hubs[(indexPath as NSIndexPath).row])
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LoadInfo"), object: nil)
        dismiss(animated: true, completion: {

            
        })
    }

}
