//
//  MainMenuHeaderView.swift
//  Living
//
//  Created by Nelson FB on 1/08/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import EZLoadingActivity
import Photos


class MainMenuHeaderView: UIViewController  {

    
    @IBOutlet weak var btn_favorites: UIButton!
    @IBOutlet weak var btn_devices: UIButton!
    @IBOutlet weak var btn_areas: UIButton!
    @IBOutlet weak var view_main: UIView!
    
    var delegate:MainMenuHeaderViewDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
        
        btn_favorites.selected = false
        btn_devices.selected = true
        btn_areas.selected = false
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        view_main.layer.cornerRadius = 30.0
    }
    @IBAction func SelectedFavorites(sender: AnyObject) {
        
        delegate?.MenuFavoriteSelected()
        btn_favorites.selected = true
        btn_devices.selected = false
        btn_areas.selected = false
        
    }
    @IBAction func SelectedDevices(sender: AnyObject) {
        delegate?.MenuDevicesSelected()
        btn_favorites.selected = false
        btn_devices.selected = true
        btn_areas.selected = false
    }

    @IBAction func SelectedRooms(sender: AnyObject) {
        delegate?.MenuRoomsSelected()
        btn_favorites.selected = false
        btn_devices.selected = false
        btn_areas.selected = true
    }

}
protocol MainMenuHeaderViewDelegate {
    // protocol definition goes here
    func MenuFavoriteSelected()
    func MenuDevicesSelected()
    func MenuRoomsSelected()
    
}

