//
//  MainMenuHeaderView.swift
//  Living
//
//  Created by Nelson FB on 1/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation
import Photos


class MainMenuHeaderView: UIViewController  {

    
    @IBOutlet weak var btn_favorites: UIButton!
    @IBOutlet weak var btn_devices: UIButton!
    @IBOutlet weak var btn_areas: UIButton!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var lbl_room_name: UILabel!
    
    var delegate:MainMenuHeaderViewDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
        
        btn_favorites.isSelected = true
        btn_devices.isSelected = false
        btn_areas.isSelected = false
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        view_main.layer.cornerRadius = 5.0 //30.0
    }
    
    func block_all(){
    
        btn_favorites.isEnabled = false
        btn_devices.isEnabled = false
        btn_areas.isEnabled = false

    }
    func unblock_all(){
        
        btn_favorites.isEnabled = true
        btn_devices.isEnabled = true
        btn_areas.isEnabled = true
        
    }
    @IBAction func SelectedFavorites(_ sender: AnyObject) {
        
        delegate?.MenuFavoriteSelected()
        btn_favorites.isSelected = true
        btn_devices.isSelected = false
        btn_areas.isSelected = false
        
    }
    @IBAction func SelectedDevices(_ sender: AnyObject) {
        delegate?.MenuDevicesSelected()
        btn_favorites.isSelected = false
        btn_devices.isSelected = true
        btn_areas.isSelected = false
    }

    @IBAction func SelectedRooms(_ sender: AnyObject) {
        delegate?.MenuRoomsSelected()
        btn_favorites.isSelected = false
        btn_devices.isSelected = false
        btn_areas.isSelected = true
    }

}
protocol MainMenuHeaderViewDelegate {
    // protocol definition goes here
    func MenuFavoriteSelected()
    func MenuDevicesSelected()
    func MenuRoomsSelected()
    
}

