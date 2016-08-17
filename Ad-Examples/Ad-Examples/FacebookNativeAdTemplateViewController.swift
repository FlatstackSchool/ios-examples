//
//  FacebookNativeAdViewController.swift
//  Ad-Examples
//
//  Created by Sergey Nikolaev on 04.04.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class FacebookNativeAdTemplateViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    
    var nativeAd: FBNativeAd?
    weak var nativeAdView: FBNativeAdView?
    
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

extension FacebookNativeAdTemplateViewController: FBNativeAdDelegate {
    
    func nativeAdDidLoad(nativeAd: FBNativeAd) {
        let attributes = FBNativeAdViewAttributes()
        attributes.backgroundColor = FSRGBA(70, 40, 120, 1)
        attributes.buttonTitleColor = UIColor.purpleColor()
        
        let view = FBNativeAdView(nativeAd: nativeAd, withType: .GenericHeight300, withAttributes: attributes)
        view.bounds = self.bannerView.bounds
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.addSubview(view)
        self.bannerView.addConstraints(FSEdgesConstraints(view))
        
        nativeAd.registerViewForInteraction(view, withViewController: self)
        
        self.nativeAdView = view
    }
    
}
