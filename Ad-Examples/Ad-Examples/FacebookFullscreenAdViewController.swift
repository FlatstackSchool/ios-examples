//
//  GoogleFullscreenAdViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 06.03.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class FacebookFullscreenAdViewController: UIViewController {
    
    var interstitial: FBInterstitialAd? = FBInterstitialAd(placementID: FacebookBanners.Fullscreen.identifier)
    
    var showAdTapped    = false
    var adLoaded        = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareAd()
    }
    
    private func prepareAd () {
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = [TestDevices]
        self.interstitial?.delegate = self
        self.interstitial?.loadAd()
    }
    
    @IBAction func fullscreenTapped(sender: AnyObject?) {
        self.showAdTapped = true
        guard self.adLoaded else {return}
        self.interstitial?.showAdFromRootViewController(self)
        self.interstitial = nil
    }
    
}

extension FacebookFullscreenAdViewController: FBInterstitialAdDelegate {
    func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
        
        self.adLoaded = true
        
        guard self.showAdTapped else {return}
        
        self.interstitial?.showAdFromRootViewController(self)
        self.interstitial = nil
    }
}
