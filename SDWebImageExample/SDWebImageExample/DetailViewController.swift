//
//  DetailViewController.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 16.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageURL: NSURL? {
        didSet {
            self.configureView()
        }
    }

    //MARK: - UI
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    //MARK: - UI helper
    private func configureView() {
        
        if testCustomCache {
            let key = FSWebImageManager.sharedManager().cacheKeyForURL(self.imageURL)
            if let image = FSWebImageManager.sharedManager().fsImageCache.imageFromDiskCacheForKey(key, type: .Original) {
                self.imageView?.image = image
                self.imageView?.setNeedsDisplay()
            }
        } else {
            let options:SDWebImageOptions = [.ProgressiveDownload, .ContinueInBackground]
            self.imageView?.sd_setImageWithURL(self.imageURL, placeholderImage: UIImage.init(named: "placeholder"), options: options, progress: { (receivedSize, expectedSize) -> Void in
                
                if expectedSize > 0 {
                    debugPrint("loaded \(Float(receivedSize / expectedSize))")
                }
                
                }) { (image, error, cacheType, imageURL) -> Void in
                    
                    debugPrint("----------------------------------------(big)")
                    debugPrint("By \(imageURL)")
                    if let lImage = image {
                        debugPrint("Has been downloaded image \(lImage)")
                    } else {
                        debugPrint("Failed download of the image with \(error)")
                    }
                    debugPrint("----------------------------------------(big)")
            }
        }
    }
}

