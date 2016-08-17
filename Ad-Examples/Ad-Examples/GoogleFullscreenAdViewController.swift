//
//  GoogleFullscreenAdViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 06.03.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class GoogleFullscreenAdViewController: UIViewController {
    
    var interstitial: GADInterstitial = GADInterstitial(adUnitID: GoogleBanners.Fullscreen.identifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareAd()
    }
    
    private func prepareAd () {
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = [TestDevices]
        self.interstitial.loadRequest(request)
    }
    
    @IBAction func fullscreenTapped(sender: AnyObject?) {
        guard self.interstitial.isReady else {
            FSDispatch_after_short(2, block: {[weak self] () -> Void in
                self?.fullscreenTapped(nil)
            })
            return
        }
        
        self.interstitial.presentFromRootViewController(self)
    }
    
}
