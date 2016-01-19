//
//  FSWebImageManager.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 10.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

class FSWebImageManager : SDWebImageManager {
    
    let webImageManager = SDWebImageManager()
    
    override func createCache() -> SDImageCache! {
        return FSImageCache()
    }
    
//    var imageCache: FSImageCache = {
//        
//        var directoryPath:String! = nil
//        let cachePaths =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        if let firstPath = cachePaths.first {
//            directoryPath = firstPath
//        } else {
//            directoryPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
//        }
//        
//        let nameSpace = NSProcessInfo.processInfo().globallyUniqueString
//        return FSImageCache(namespace: "original and thumbnail")
//    }()
    
//    let operationQueue: NSOperationQueue = {
//        let operationQueue = NSOperationQueue()
//        operationQueue.maxConcurrentOperationCount = 3
//        operationQueue.name = "com.Rubin.RNImageCacheManager.OperationQueue"
//        return operationQueue
//    }()
    
//    class func sharedManager() -> FSWebImageManager {
//        struct Static {
//            static var instance: FSWebImageManager?
//            static var token: dispatch_once_t = 0
//        }
//        
//        dispatch_once(&Static.token) {
//            Static.instance = FSWebImageManager()
//        }
//        
//        return Static.instance!
//    }
    
    override func downloadImageWithURL(url: NSURL!, options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock!, completed completedBlock: SDWebImageCompletionWithFinishedBlock!) -> SDWebImageOperation! {
        
    }
    
    
    
//    private func loadThumbnail(player: RNPlayer) -> UIImage? {
//        
//        let defaultImage = UIImage(named: "_".join(["player","\(player.serverID!)"]))
//        if defaultImage != nil {
//            return defaultImage
//        }
//
//        if let imageURL = player.avatarURL, let absoluteURL = imageURL.absoluteString {
//            var image:UIImage? = self.imageCache.imageFromDiskCacheForKey(absoluteURL, isThumbnail:true)
//            if let cachedImage = image {
//                return cachedImage
//            }
//        }
//        return nil
//    }
//    
//    func downloadImageInCache(player: RNPlayer!, isThumbnail: Bool, completionBlock:RNImageCacheCompletionHandler) -> RNImageCacheOperation? {
//        
//        if let imageURL = player.avatarURL, let absoluteURL = imageURL.absoluteString {
//            
//            for operation in self.operationQueue.operations {
//                if let operation = operation as? RNImageCacheOperation {
//                    if operation.identifier == imageURL.absoluteString && !operation.cancelled  {
//                        return operation
//                    }
//                }
//            }
//            
//            let thumbnail: UIImage? = self.loadThumbnail(player)
//            
//            if thumbnail == nil {
//                
//                let operation = RNImageCacheOperation(imageURL: imageURL,
//                    withThumbnail: true,
//                    completionHandler: completionBlock)
//                operation.identifier = imageURL.absoluteString
//                self.operationQueue.addOperation(operation)
//                return operation
//                
//            } else {
//                
//                if isThumbnail {
//                    
//                    if let completionBlock = completionBlock {
//                        completionBlock(downloadedImage: nil, smallDownloadedImage: thumbnail, error: nil)
//                    }
//                    
//                } else {
//                    
//                    var image:UIImage? = self.imageCache.imageFromDiskCacheForKey(absoluteURL, isThumbnail:false)
//                    if let cachedImage = image {
//                        if let completionBlock = completionBlock {
//                            completionBlock(downloadedImage: cachedImage, smallDownloadedImage: thumbnail, error: nil)
//                        }
//                    } else {
//                        let operation = RNImageCacheOperation(imageURL: imageURL,
//                            withThumbnail: false,
//                            completionHandler: completionBlock)
//                        operation.identifier = imageURL.absoluteString
//                        self.operationQueue.addOperation(operation)
//                        return operation
//                    }
//                }
//                
//            }
//        }
//        
//        return nil
//    }
}