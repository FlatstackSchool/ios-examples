//
//  FSWebImageManager.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 10.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit


typealias FSWebImageCompletionWithFinishedBlock = (images:[FSImageCacheType : UIImage?], error: NSError!, cacheType: SDImageCacheType, finished: Bool, imageURL: NSURL!) -> Void

class FSWebImageManager : SDWebImageManager {
    
    var fsImageCache: FSImageCache! {
        return self.imageCache as! FSImageCache
    }
    
    func createCache() -> SDImageCache! {
        return FSImageCache.sharedImageCache()
    }
    
    override class func sharedManager() -> FSWebImageManager {
        struct Static {
            static var instance: FSWebImageManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FSWebImageManager()
        }
        
        return Static.instance!
    }
    
    func downloadImageWithURL(url: NSURL, types:Set<FSImageCacheType> = FSImageCacheType.allTypes(), options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock? = nil, completed completedBlock:FSWebImageCompletionWithFinishedBlock? = nil) -> SDWebImageOperation! {

        let key = super.cacheKeyForURL(url)
        for type in types {
            if self.fsImageCache.diskImageExistsWithKey(key, type: type) == false {
                self.fsImageCache.removeImageForKey(key, type: .Original)
                break
            }
        }
        
        return super.downloadImageWithURL(url, options: options, progress: progressBlock) {[weak self] (image, error, cacheType, finished, imageURL) -> Void in
            
            if let sself = self {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let images = sself.fsImageCache.imageFromDiskCacheForKey(key, types: types)
                    completedBlock?(images: images, error: error, cacheType: cacheType, finished: finished, imageURL: imageURL)
                })
            }
        }
    }
}

//MARK: - access to data by more type
extension FSWebImageManager {
    
    func saveImageToCache(image: UIImage, types:Set<FSImageCacheType> = FSImageCacheType.allTypes(), forURL url: NSURL) {
        let key = super.cacheKeyForURL(url)
        self.fsImageCache.storeImage(image, types: types, forKey: key)
    }
}

//MARK: - unavailable
extension FSWebImageManager {
    @available(iOS, unavailable, renamed="saveImageToCache(<#image: UIImage#>, <#types:Set<FSImageCacheType>#>, <#forURL url: NSURL#>)")
    override func saveImageToCache(image: UIImage!, forURL url: NSURL!) {}
}

