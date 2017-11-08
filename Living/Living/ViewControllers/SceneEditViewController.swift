//
//  SceneEditViewController.swift
//  Living
//
//  Created by Nelson FB on 23/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Presentr
import Localize_Swift


class SceneEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SceneEndpointCellDelegate {

    var theme:ThemeManager = ThemeManager()

    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var btn_Scene: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_run: UIButton!
    
    var scene = Scene()
    var editMode:Bool = false
    var selectedScene = 0
    var payloads:[Payload] = [Payload]()
    
    @IBOutlet weak var img_icon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SceneEndpointCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectIconNewDeviceNotification), name:NSNotification.Name(rawValue: "SelectIconNewDevice"), object: nil)

        self.tableView.isEditing = true
        
        if(editMode){
            txt_name.text = scene.name
           // btn_run.isHidden = false
            self.title = scene.name
            let image = UIImage(named: "play_32")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            navigationItem.rightBarButtonItem  = UIBarButtonItem(image:image , style: .plain, target: self, action:#selector(RunScene))
        }else{
            //btn_run.isHidden = true
            self.title = "New Scene"
        }

        self.navigationController?.navigationBar.barTintColor = UIColor(theme.MainColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if scene.image != "" {
            img_icon.image = UIImage(named:scene.ImageNamed())!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let endpoints = ArSmartApi.sharedApi.hub?.endpoints.noSensorEndpoints()
        return (endpoints?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let endpoints = ArSmartApi.sharedApi.hub?.endpoints.noSensorEndpoints()
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let endpoint = endpoints![indexPath.item]
        
        
        if endpoint.ui_class_command == "ui-hue"{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHue") as! SceneHueEndpointCell

            
            //let scene_payload = scene.payload
            let image = UIImage(named:endpoint.ImageNamed())!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            let endpoint_name = String(format:"%@ %@",endpoint.name, endpoint.getEndpointTypeString())
            
            cell.endpoint_image.image = image
            cell.endpoint_name.text = endpoint_name
            cell.endpoint = endpoint
            cell.delegate = self
            cell.applyPayload(tableView: tableView, indexPath: indexPath,scene:scene)
            return cell
        
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SceneEndpointCell
            //let cell = SceneEndpointCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
            //let scene_payload = scene.payload
            let image = UIImage(named:endpoint.ImageNamed())!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            let endpoint_name = String(format:"%@ %@",endpoint.name, endpoint.getEndpointTypeString())
            
            cell.endpoint_image.image = image
            cell.endpoint_name.text = endpoint_name
            cell.endpoint = endpoint
            cell.delegate = self
            cell.applyPayload(tableView: tableView, indexPath: indexPath,scene:scene)
            
            
            
            return cell
        }

    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?{
        return "Dispositivos"
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedScene = (indexPath as NSIndexPath).row
        
         let endpoints = ArSmartApi.sharedApi.hub?.endpoints.noSensorEndpoints()
         let endpoint = endpoints![indexPath.item]
        
        if (endpoint.isHue()) {
        
            //TODO: crear payload de hue
            let selectedCell:SceneHueEndpointCell = tableView.cellForRow(at: indexPath) as! SceneHueEndpointCell
            selectedCell.contentView.inputAccessoryView?.backgroundColor = UIColor.white
            self.payloads.append(selectedCell.payload)
            
        }else if (endpoint.isSonos()){
            
            let selectedCell:SceneEndpointCell = tableView.cellForRow(at: indexPath) as! SceneEndpointCell
            selectedCell.contentView.inputAccessoryView?.backgroundColor = UIColor.white
            
            
            self.payloads.append(selectedCell.payload_level)
            self.payloads.append(selectedCell.payload_switch)
        }else{
        
            let selectedCell2:SceneEndpointCell = tableView.cellForRow(at: indexPath) as! SceneEndpointCell
            selectedCell2.contentView.inputAccessoryView?.backgroundColor = UIColor.white
            
            if(selectedCell2.endpoint.isLevel()){
                self.payloads.append(selectedCell2.payload_level)
            }else if(selectedCell2.endpoint.isSwitch()){
                self.payloads.append(selectedCell2.payload_switch)
            }else{
                self.payloads.append(selectedCell2.payload)
            }
            
        }

        

        //performSegueWithIdentifier("EditEndpoint", sender: nil)
        print("Payloads:",payloads.count)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
        selectedScene = (indexPath as NSIndexPath).row
        
        let endpoints = ArSmartApi.sharedApi.hub?.endpoints.noSensorEndpoints()
        let endpoint = endpoints![indexPath.item]
        
        if (endpoint.isHue()) {
            let selectedCell:SceneHueEndpointCell = tableView.cellForRow(at: indexPath) as! SceneHueEndpointCell
            let index_switch = self.payloads.index(where: {$0.endpoint_id == selectedCell.payload.endpoint_id})

            
            if(index_switch != nil){
                self.payloads.remove(at: index_switch!)
            }

            
        }else{
        
            let selectedCell:SceneEndpointCell = tableView.cellForRow(at: indexPath) as! SceneEndpointCell
            selectedCell.contentView.inputAccessoryView?.backgroundColor = UIColor.white
            
            if(selectedCell.endpoint.ui_class_command != "ui-sonos"){
                
                if(selectedCell.mode == SceneEndpointCell.SceneEndpointCellMode.level){
                    self.payloads.remove(at: self.payloads.index(where: {$0.endpoint_id == selectedCell.payload_level.endpoint_id})!)
                }else if(selectedCell.mode == SceneEndpointCell.SceneEndpointCellMode.switch){
                    self.payloads.remove(at: self.payloads.index(where: {$0.endpoint_id == selectedCell.payload_switch.endpoint_id})!)
                }else{
                    self.payloads.remove(at: self.payloads.index(where: {$0.endpoint_id == selectedCell.payload.endpoint_id})!)
                }
                
                
                
            }else{
                
                let index_switch = self.payloads.index(where: {$0.endpoint_id == selectedCell.payload_switch.endpoint_id})
                let index_level = self.payloads.index(where: {$0.endpoint_id == selectedCell.payload_level.endpoint_id})
                
                if(index_switch != nil){
                    self.payloads.remove(at: index_switch!)
                }
                if(index_switch != nil){
                    self.payloads.remove(at: index_level!)
                }
                
            }
        }
        

        print("Payloads:",payloads.count)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3)!
    }




    @IBAction func SaveScene(_ sender: AnyObject) {
        
        if(editMode){
            Update(silent: false)
        }else{
            Save()
        }
        //self.RunScene(sender)

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
                
                    
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 130)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText(result)
                
                
                }else{
                
                    let width = ModalSize.custom(size: 240)
                    let height = ModalSize.custom(size: 130)
                    let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                    
                    presenter2.transitionType = .crossDissolve // Optional
                    let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                    self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                    vc2.setText("Scene succesfully created...".localized())
                
                }
            }
        }else{
        
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("The scene cant be empty...".localized())
            
        }
        

        
        
        
    }
    
    func Update(silent:Bool){
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
                    
                    if (!silent) {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 130)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        vc2.setText(result)
                    }
                   
                    
                    
                }else{
                    if (!silent) {
                        let width = ModalSize.custom(size: 240)
                        let height = ModalSize.custom(size: 130)
                        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
                        
                        presenter2.transitionType = .crossDissolve // Optional
                        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
                        self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                        vc2.setText("Scene has been updated...".localized())
                        
                    }
                    
                    
                }
            }
        }else{
            
            let width = ModalSize.custom(size: 240)
            let height = ModalSize.custom(size: 130)
            let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
            
            presenter2.transitionType = .crossDissolve // Optional
            let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)
            self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
            vc2.setText("The scene's name can't be empty...".localized())
            
        }
        

    }

    func getPayload(_ id:Int)->Payload?{
        let index = scene.payload.index(where: {$0.endpoint_id == id})
        if (index != nil){

            
            return scene.payload[index!]
            
        }else{
            return nil
        }
    }
    
    func getSonosPayload(_ id:Int,function_name:String)->Payload?{
        if let index = scene.payload.index(where: {($0.endpoint_id == id) && ($0.function_name == function_name)}){
            return scene.payload[index]
        }else{
            return nil
        }

    }
    
    func getSonosPayloadFromScene(_ id:Int,function_name:String)->Payload?{
        if let index = self.scene.payload.index(where: {($0.endpoint_id == id) && ($0.function_name == function_name)}){
            return scene.payload[index]
        }else{
            return nil
        }
        
    }
    
    
    
    func ChangedPayload(_ payload: Payload) {
        
        if (payload.target == "hue") {
            
            // Aqui se define el payload del hue
            
            if let index = payloads.index(where: {$0.endpoint_id == payload.endpoint_id}){
                payloads.remove(at: index) // Se revento
                payloads.append(payload)
            }
            
        }else if(payload.target != "sonos"){
            
            if let index = payloads.index(where: {$0.endpoint_id == payload.endpoint_id}){
                payloads.remove(at: index) // Se revento
                payloads.append(payload)
            }
            
            
            
        }else{
            
            print("Change Payload sonos",payload.function_name)
            if let index = payloads.index(where: {($0.endpoint_id == payload.endpoint_id) && ($0.function_name == payload.function_name) }){
                
                print("Change Payload sonos value:",index, payload.function_name)
                payloads.remove(at: index) // Se revento
                payloads.append(payload)
            }
            
            
        }
        

        if(editMode){
            Update(silent: true)
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
    
     func RunScene() {
        let token = ArSmartApi.sharedApi.getToken()
        let hub = ArSmartApi.sharedApi.hub?.hid
        let width = ModalSize.custom(size: 240)
        let height = ModalSize.custom(size: 130)
        let presenter2 = Presentr(presentationType: .custom(width: width, height: height, center:ModalCenterPosition.center))
        
        presenter2.transitionType = .crossDissolve // Optional
        let vc2 = LocalAlertViewController(nibName: "LocalAlertViewController", bundle: nil)

        scene.run(token, hub: hub!) { (IsError, result) in
            if(!IsError){
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.setText("The scene was performed...".localized())
            }else{
                self.customPresentViewController(presenter2, viewController: vc2, animated: true, completion: nil)
                vc2.setText("There is a problem running the scene....".localized())
            }
        }
    }
    
    @IBAction func GoBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goSelectIcon(_ sender: Any) {
    }
    
    func SelectIconNewDeviceNotification(_ notification: Notification){
        
        let image:String = notification.object as! String
        
        img_icon.image = UIImage(named:image)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        img_icon.tintColor = ThemeManager.init().GetUIColor("#2CC2BE")
        
        //var selected_room = notification.object as! Room
        //self.endpoint.image = Endpoint.NameImages(name: image)
        
        self.scene.image = Scene.NameImages(name: image)
    }

}
