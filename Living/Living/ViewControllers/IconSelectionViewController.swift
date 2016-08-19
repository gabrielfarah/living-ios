//
//  IconSelectionViewController.swift
//  Living
//
//  Created by Nelson FB on 28/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

//
//  WelcomeViewController.swift
//  Living
//
//  Created by Nelson FB on 28/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import EZLoadingActivity
import Photos


class IconSelectionViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    let mySpecialNotificationKey = "SelectIconNewDevice"
    
    
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var btn_camera: UIButton!
    
        @IBOutlet weak var collectionView: UICollectionView!

    let icons = DeviceIcons()
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        fetchPhotos ();
        
        let nib = UINib(nibName: "PhotoLibraryCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        

    }
    var images:[String] = [String]()
    // <-- Array to hold the fetched images
    var totalImageCountNeeded:Int! // <-- The number of images to fetch
    
    func fetchPhotos () {
        images = icons.icons;
        totalImageCountNeeded = 10

    }
    

    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let identifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! PhotoLibraryCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        
        let img:UIImage = UIImage(named:self.images[indexPath.item])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        //theImageView.image = theImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        //theImageView.tintColor = UIColor.redColor()

        //cell.itemImageView.tintColor = UIColor.redColor()
        
        cell.setGalleryItem(img)
        //cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        index = indexPath.item
        selectImage()

    }


    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //imagePicked.image = image
        print("Ha escogido una imagen")
        self.selectImage();
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    func selectImage(){
        
        //TODO: Enviar imagen a la vista anterior
        
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self.images[index])
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    @IBAction func Close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
}

