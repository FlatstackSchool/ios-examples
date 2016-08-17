//
//  GoogleBottomBannerViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 06.03.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class FacebookBottomBannerViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareBanner()
    }
    
    private func prepareBanner () {
        
        let identifier = FacebookBanners.BottomBanner.identifier
        let size = kFBAdSizeHeight50Banner
        
        let adView = FBAdView(placementID: identifier, adSize: size, rootViewController: self)
        adView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.addSubview(adView)
        self.bannerView.addConstraints(FSEdgesConstraints(adView))
        adView.loadAd()
        
    }
    
}
