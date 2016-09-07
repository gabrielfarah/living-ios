//
//  SceneEditViewController.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Presentr

class SceneEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SceneEndpointCellDelegate {


    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var btn_Scene: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var scene = Scene()
    var editMode:Bool = false
    var selectedScene = 0
    var payloads:[Payload] = [Payload]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SceneEndpointCell", bundle: nil)

        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")

        self.tableView.editing = true
        
        if(editMode){
            txt_name.text = scene.name
        
        }
        
        initPayloads()
        
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
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 101
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (ArSmartApi.sharedApi.hub?.endpoints.count())!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell:SceneEndpointCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! SceneEndpointCell
        
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let endpoint = (ArSmartApi.sharedApi.hub?.endpoints.endpoints[indexPath.item])!
        let scene_payload = scene.payload
        let image = UIImage(named:endpoint.ImageNamed())!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

        
        let endpoint_name = String(format:"%@ %d %@",endpoint.name,endpoint.node, endpoint.getEndpointTypeString())
        cell.endpoint_image.image = image
        cell.endpoint_name.text = endpoint_name
        cell.endpoint = endpoint
        
        
        
        if(endpoint.ui_class_command == "ui-sonos"){
            
            // Se necesita verificar si existe dos payloads
            
            
            let target = (endpoint.ui_class_command == "ui-sonos") ? "sonos" : ""
            if let payload_level = getSonosPayload(endpoint.id,function_name: "set_volume"){
            
                if(payload_level.endpoint_id != 0 ){
                    
                    let payload = Payload(type:payload_level.type,node:payload_level.node,value:payload_level.value,target:target,endpoint_id:payload_level.endpoint_id,ip:payload_level.ip,function_name:"set_volume",parameters:payload_level.parameters)
                    cell.payload_level = payload
                    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
                    
                }else{
                    let payload_level = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"set_volume",parameters:[])
                    
                    
                    
                    cell.payload_level = payload_level
                    
                }
            
            }else{
                let payload_level = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"set_volume",parameters:[])
                
                
                cell.payload_level = payload_level
            
            }
            

            if let payload_switch = getSonosPayload(endpoint.id,function_name: "play"){
                if(payload_switch.endpoint_id != 0){
                    
                    let payload = Payload(type:payload_switch.type,node:payload_switch.node,value:payload_switch.value,target:target,endpoint_id:payload_switch.endpoint_id,ip:payload_switch.ip,function_name:"play",parameters:payload_switch.parameters)
                    cell.payload_switch = payload
                    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
                    
                }else{
                    
                    
                    let payload_switch = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"play",parameters:[])
                    
                    
                    cell.payload_switch = payload_switch
                }
            }else{
                let payload_switch = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:target,endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:"play",parameters:[])
                cell.payload_switch = payload_switch

            }


        }else{
            if let real_payload = getPayload(endpoint.id){
            
                if(real_payload.endpoint_id != 0){
                    let payload = Payload(type:real_payload.type,node:real_payload.node,value:real_payload.value,target:real_payload.target,endpoint_id:real_payload.endpoint_id,ip:real_payload.ip,function_name:real_payload.function_name,parameters:real_payload.parameters)
                    
                    
                    if(endpoint.isSwitch()){
                        cell.payload_switch = payload
                    }else if(endpoint.isLevel()){
                        cell.payload_level = payload
                    }else{
                    cell.payload = payload
                    }
                    
                    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
                    
                }else{
                    
                    let payload = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:"",endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:endpoint.GetFunctionValue(),parameters:[])
                    if(endpoint.isSwitch()){
                        cell.payload_switch = payload
                    }else if(endpoint.isLevel()){
                        cell.payload_level = payload
                    }else{
                        cell.payload = payload
                    }
                    
                }
            }else{
                let payload = Payload(type:endpoint.getEndpointTypeString(),node:endpoint.node,value:0,target:"",endpoint_id:endpoint.id,ip:endpoint.ip_address,function_name:endpoint.GetFunctionValue(),parameters:[])
                if(endpoint.isSwitch()){
                    cell.payload_switch = payload
                }else if(endpoint.isLevel()){
                    cell.payload_level = payload
                }else{
                    cell.payload = payload
                }
            }
            

        
        
        }
        
        
       
        



    

        
        cell.delegate = self
        
        
        
        if (endpoint.isLevel()){
            cell.levelMode()
        }else if(endpoint.isSwitch()){
            cell.switchMode()
        }else if(endpoint.isSonos()){
            cell.sonosMode()
        }else{
            cell.noneMode()
        
        }
        
        
        
        //cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        //cell.textLabel?.text = self.scenes.scenes[indexPath.row].name
        
        return cell
    }
    
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String
    {
        return "Dispositivos"
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedScene = indexPath.row
        
        let selectedCell:SceneEndpointCell = tableView.cellForRowAtIndexPath(indexPath) as! SceneEndpointCell

        selectedCell.contentView.inputAccessoryView?.backgroundColor = UIColor.whiteColor()
        
        
        if(selectedCell.endpoint.ui_class_command == "ui-sonos"){
                // Son dos payloads en este caso.
                self.payloads.append(selectedCell.payload_level)
                self.payloads.append(selectedCell.payload_switch)
        }else{
            if(selectedCell.endpoint.isLevel()){
                self.payloads.append(selectedCell.payload_level)
            }else if(selectedCell.endpoint.isSwitch()){
                self.payloads.append(selectedCell.payload_switch)
            }else{
            self.payloads.append(selectedCell.payload)
            
            }
            
        }


        

        //performSegueWithIdentifier("EditEndpoint", sender: nil)
        print("Payloads:",payloads.count)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        
        selectedScene = indexPath.row
        
        let selectedCell:SceneEndpointCell = tableView.cellForRowAtIndexPath(indexPath) as! SceneEndpointCell
        
        selectedCell.contentView.inputAccessoryView?.backgroundColor = UIColor.whiteColor()

        if(selectedCell.endpoint.ui_class_command != "ui-sonos"){
            
            if(selectedCell.mode == SceneEndpointCell.SceneEndpointCellMode.Level){
                self.payloads.removeAtIndex(self.payloads.indexOf({$0.endpoint_id == selectedCell.payload_level.endpoint_id})!)
            }else if(selectedCell.mode == SceneEndpointCell.SceneEndpointCellMode.Switch){
                self.payloads.removeAtIndex(self.payloads.indexOf({$0.endpoint_id == selectedCell.payload_switch.endpoint_id})!)
            }else{
            self.payloads.removeAtIndex(self.payloads.indexOf({$0.endpoint_id == selectedCell.payload.endpoint_id})!)
            }
            
            
        
        }else{
            
            let index_switch = self.payloads.indexOf({$0.endpoint_id == selectedCell.payload_switch.endpoint_id})
            let index_level = self.payloads.indexOf({$0.endpoint_id == selectedCell.payload_level.endpoint_id})
            
            if(index_switch != nil){
                self.payloads.removeAtIndex(index_switch!)
            }
            if(index_switch != nil){
                self.payloads.removeAtIndex(index_level!)
            }
            
            
        
        }
        print("Payloads:",payloads.count)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        

        return UITableViewCellEditingStyle(rawValue: 3)!

        
    }




    @IBAction func SaveScene(sender: AnyObject) {
        
        if(editMode){
            Update()
        }else{
            Save()
        }
        
        
        
        
    }
    func Save(){
    
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        
        let name:String = txt_name.text!
        
        
        if(!name.isEmpty){
            //TODO:Obtener todas las escenas
            print("Payloads",self.payloads.count)
            
            let scene = Scene()
            scene.name = name
            scene.payload = payloads
            scene.save(token, hub: hub!) { (IsError, result) in
                if(IsError){
                
                    
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText(result)
                
                
                }else{
                
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("Escena creada con éxito")
                
                }
            }
        }else{
        
            
            let width = ModalSize.Custom(size: 240)
            let height = ModalSize.Custom(size: 130)
            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("El nombre de la escena no puede estar vacio")
            
        }
        

        
        
        
    }
    
    func Update(){
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        
        
        let name:String = txt_name.text!
        
        
        if(!name.isEmpty){
            //TODO:Obtener todas las escenas
            print("Payloads",self.payloads.count)
            

            scene.name = name
            scene.payload = payloads
            scene.update(token, hub: hub!) { (IsError, result) in
                if(IsError){
                    
                    
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText(result)
                    
                    
                }else{
                    
                    let width = ModalSize.Custom(size: 240)
                    let height = ModalSize.Custom(size: 130)
                    let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
                    
                    presenter2.transitionType = .CrossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("Escena actualizada con éxito")
                    

                    
                    
                }
            }
        }else{
            
            
            let width = ModalSize.Custom(size: 240)
            let height = ModalSize.Custom(size: 130)
            let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
            
            presenter2.transitionType = .CrossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("El nombre de la escena no puede estar vacio")
            
        }
        

    }
    
    
    
    func getPayload(id:Int)->Payload?{
        let index = scene.payload.indexOf({$0.endpoint_id == id})
        if (index != nil){

            
            return scene.payload[index!]
            
        }else{
            return nil
        }
    }
    
    func getSonosPayload(id:Int,function_name:String)->Payload?{
        if let index = scene.payload.indexOf({($0.endpoint_id == id) && ($0.function_name == function_name)}){
            return scene.payload[index]
        }else{
            return nil
        }

    }
    
    func getSonosPayloadFromScene(id:Int,function_name:String)->Payload?{
        if let index = self.scene.payload.indexOf({($0.endpoint_id == id) && ($0.function_name == function_name)}){
            return scene.payload[index]
        }else{
            return nil
        }
        
    }
    
    
    
    func ChangedPayload(payload: Payload) {
        
        if(payload.target != "sonos"){
            
            if let index = payloads.indexOf({$0.endpoint_id == payload.endpoint_id}){
                payloads.removeAtIndex(index) // Se revento
                
                payloads.append(payload)
            }
            
            

        }else{
            
            print("Change Payload sonos",payload.function_name)
            if let index = payloads.indexOf({($0.endpoint_id == payload.endpoint_id) && ($0.function_name == payload.function_name) }){
                
                print("Change Payload sonos value:",index, payload.function_name)
                payloads.removeAtIndex(index) // Se revento
                payloads.append(payload)
            }
            

        }
        

        
        
        
    }
    
    func initPayloads(){
    
        let endpoints = (ArSmartApi.sharedApi.hub?.endpoints.endpoints)
        for endpoint:Endpoint in endpoints!{
            
            if(endpoint.ui_class_command == "ui-sonos"){
                
                if let payload_play = getSonosPayload(endpoint.id, function_name: "play"){
                    payloads.append(payload_play)
                }
                if let payload_volume = getSonosPayload(endpoint.id, function_name: "set_volume"){
                    payloads.append(payload_volume)
                }

                
                
                
            }else{
                
                if let payload = getPayload(endpoint.id){
                    payloads.append(payload)
                }
                    

                
                
                
            }
            

            

        
        }
        print("end endpoints")
    }
    
    @IBAction func RunScene(sender: AnyObject) {
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        let width = ModalSize.Custom(size: 240)
        let height = ModalSize.Custom(size: 130)
        let presenter2 = Presentr(presentationType: .Custom(width: width, height: height, center:ModalCenterPosition.Center))
        
        presenter2.transitionType = .CrossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)

        scene.run(token, hub: hub!) { (IsError, result) in
            if(!IsError){
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.setText("Se ejecutó la escena")
            }else{
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.setText("Hubó un problema en la escena")
            }
        }
    }
    
    @IBAction func GoBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
