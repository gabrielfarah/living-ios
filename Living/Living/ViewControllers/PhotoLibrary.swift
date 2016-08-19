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
import CollectionViewWaterfallLayout

class PhotoLibrary: UIViewController,UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    let mySpecialNotificationKey = "com.andrewcbancroft.specialNotificationKey"
    
    
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var btn_camera: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style();
        
        
        fetchPhotos ();
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style(){
        
        let layout = CollectionViewWaterfallLayout()
        let nib = UINib(nibName: "PhotoLibraryCell", bundle: nil)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.headerInset = UIEdgeInsetsMake(5, 0, 0, 0)
        layout.headerHeight = 5
        layout.footerHeight = 5
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
    }
    var images:NSMutableArray! // <-- Array to hold the fetched images
    var totalImageCountNeeded:Int! // <-- The number of images to fetch
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 10
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.images.addObject(image!)
                    
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    } else {
                        // Else you have completed creating your array
                        print("Completed array: \(self.images)")
                    }
                })
            }
        }
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
        cell.setGalleryItem(self.images[indexPath.item] as! UIImage)
        cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.selectImage(self.images[indexPath.item] as! UIImage);
    }
    // MARK: WaterfallLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let random = Int(arc4random_uniform((UInt32(100))))
        if (indexPath.item%2==0){
            return CGSize(width: 140, height: 140 + random)
        }else{
            return CGSize(width: 140, height: 140 + random)
        }
        
        
    }
    @IBAction func UseCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //imagePicked.image = image
        print("Ha escogido una imagen")
        self.selectImage(image);
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    func selectImage(image:UIImage){
    
        //TODO: Enviar imagen a la vista anterior
        
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: image)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }

    @IBAction func Close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
