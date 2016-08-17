//
//  FacebookNativeAdViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 04.04.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class FacebookNativeAdViewController: UIViewController {
    
    //Facebook outlets
    @IBOutlet weak var adIconImageView: UIImageView!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adBodyLabel: UILabel!
    @IBOutlet weak var adCallToActionButton: UIButton!
    @IBOutlet weak var adSocialContextLabel: UILabel!
    @IBOutlet weak var sponsoredLabel: UILabel!
    
    var adCoverMediaView: FBMediaView?
    
    @IBOutlet weak var adView: UIView!
    //---
    
    var nativeAd: FBNativeAd?
    var adChoicesView: FBAdChoicesView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNativeAd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNativeAd () {
        self.nativeAd = FBNativeAd(placementID: FacebookBanners.Native.identifier)
        self.nativeAd?.delegate = self
        self.nativeAd?.loadAd()
    }
    

}

extension FacebookNativeAdViewController: FBNativeAdDelegate {
    
    func nativeAdDidLoad(nativeAd: FBNativeAd) {
        
        self.adTitleLabel.text = nativeAd.title
        self.adBodyLabel.text = nativeAd.body
        self.adSocialContextLabel.text = nativeAd.socialContext
        
        self.adCallToActionButton.setTitle(nativeAd.callToAction, forState: .Normal)
        
        self.adTitleLabel.text = nativeAd.title
        
        // Add adChoicesView
        self.adChoicesView = FBAdChoicesView(nativeAd: nativeAd)
        self.adView.addSubview(self.adChoicesView!)
        self.adChoicesView?.updateFrameFromSuperview()
        
        // Icon
        self.nativeAd?.icon?.loadImageAsyncWithBlock({[weak self] (image: UIImage?) in
            self?.adIconImageView.image = image
        })
        
        // Allocate a FBMediaView to contain the cover image or native video asset
        self.adCoverMediaView = FBMediaView(nativeAd: nativeAd)
        self.adView.addSubview(self.adCoverMediaView!)
        
        nativeAd.registerViewForInteraction(view, withViewController: self)
        
    }
    
}
