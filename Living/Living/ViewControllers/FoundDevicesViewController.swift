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
import Localize_Swift

class FoundDevicesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_back: UIView!
    

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
        
            self.tableView.isHidden = false

            self.lbl_founded.isHidden = false
        }else{
            self.tableView.isHidden = true

            self.lbl_founded.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goBack(_ sender: AnyObject) {
        
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = endpoints[(indexPath as NSIndexPath).row].name
        cell.detailTextLabel?.text = endpoints[(indexPath as NSIndexPath).row].uid
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        selected_endpoint_index = (indexPath as NSIndexPath).row
        
        // verificar si el endpoint ya existe
        let endpoint = endpoints[(indexPath as NSIndexPath).row]
        if (ArSmartApi.sharedApi.hub?.endpoints.hasEndpoint(endpoint_id: endpoint.node))!{
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter.transitionType = .crossDissolve // Optional
            presenter.dismissOnTap = true
            let vc = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
            vc.setText("This device is already registered...".localized())
            return
        
        }else{
            self.performSegue(withIdentifier: "ShowAddNewDevice", sender: nil)
        }
        
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ShowAddNewDevice") {
            // pass data to next view
            let destinationVC = segue.destination as! DeviceEditViewController
            let endpoint = endpoints[selected_endpoint_index].CreateEndpoint()
            destinationVC.endpoint = endpoint
            print("end")
            
        }
    }
    
}
