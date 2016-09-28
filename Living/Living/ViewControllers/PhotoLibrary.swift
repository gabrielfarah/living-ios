//
//  WelcomeViewController.swift
//  Living
//
//  Created by Nelson FB on 28/06/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import Foundation

import UIKit
import Photos
import CollectionViewWaterfallLayout

class PhotoLibrary: UIViewController,UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    let mySpecialNotificationKey = "com.arsmart.specialNotificationKey"
    
    
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
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
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
    func fetchPhotoAtIndexFromEnd(_ index:Int) {
        
        let imgManager = PHImageManager.default()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1 - index) , targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.images.add(image!)
                    
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let identifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoLibraryCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.setGalleryItem(self.images[(indexPath as NSIndexPath).item] as! UIImage)
        cell.backgroundColor = UIColor.yellow // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\((indexPath as NSIndexPath).item)!")
        self.selectImage(self.images[(indexPath as NSIndexPath).item] as! UIImage);
    }
    // MARK: WaterfallLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let random = Int(arc4random_uniform((UInt32(100))))
        if ((indexPath as NSIndexPath).item%2==0){
            return CGSize(width: 140, height: 140 + random)
        }else{
            return CGSize(width: 140, height: 140 + random)
        }
        
        
    }
    @IBAction func UseCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        //imagePicked.image = image
        print("Ha escogido una imagen")
        self.selectImage(image);
        self.dismiss(animated: true, completion: nil);
        
    }
    func selectImage(_ image:UIImage){
    
        //TODO: Enviar imagen a la vista anterior
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialNotificationKey), object: image)
        
        self.dismiss(animated: true, completion: nil)
    
    }

    @IBAction func Close(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
}
