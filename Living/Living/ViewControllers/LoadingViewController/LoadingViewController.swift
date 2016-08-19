//
//  LoadingViewController.swift
//  Living
//
//  Created by Nelson FB on 5/07/16.
//  Copyright © 2016 ar-smart. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    @IBOutlet weak var lbl_menssage: UILabel!
    @IBOutlet weak var activity_main: UIActivityIndicatorView!
    
    @IBOutlet weak var view_loader: UIView!
    
    var dismissAnimated: Bool = true
    var autoDismiss: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let frame = CGRect(x:0,y:0,width:40,height:40)
        
        let activity_indicator = NVActivityIndicatorView(frame:frame, type:NVActivityIndicatorType.LineScalePulseOutRapid )
        view_loader.addSubview(activity_indicator)
        activity_indicator.startAnimation()
        
    }
    
    // MARK: Helper's
    
    func dismiss(){
        guard autoDismiss else { return }
        dismissViewControllerAnimated(dismissAnimated, completion: nil)
    }
    
}
