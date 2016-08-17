//
//  GoogleBottomBannerViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 06.03.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class GoogleBottomBannerViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareBanner()
    }
    
    private func prepareBanner () {
        self.bannerView.adUnitID = GoogleBanners.BottomBanner.identifier
        self.bannerView.rootViewController = self
        self.bannerView.adSize = kGADAdSizeSmartBannerPortrait
        
        let request = GADRequest()
        request.testDevices = TestDevices
        
        self.bannerView.loadRequest(request)
    }
    
}
