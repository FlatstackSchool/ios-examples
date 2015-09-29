//
//  FSImageCache.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 10.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

enum FSImageCacheType : String {
    case Original = ""
    case Thumbnail = "thumbnail"
    case Blur = "blur"
    
    static func allTypes() -> Set<FSImageCacheType> {
        return [.Original, .Thumbnail, .Blur]
    }
}

typealias BlurValues = (blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat)

class FSImageCache: SDImageCache {
    
    var thumbnailSize: CGSize = CGSize.init(width: 200, height: 200)
    var blurSetting: BlurValues = (blurRadius: 15, tintColor: UIColor(white: 1.0, alpha: 0.2), saturationDeltaFactor: 1.2)
    
    override init() {
        super.init()
        self.initialization()
    }
    
    override init!(namespace ns: String) {
        super.init(namespace: ns)
        self.initialization()
    }
    
    override init!(namespace ns: String, diskCacheDirectory directory: String) {
        super.init(namespace: ns, diskCacheDirectory: directory)
        self.initialization()
    }
    
    private func initialization() {
        self.maxCacheSize     = 1024 * 1024 * 100   // 100 mb on disk
        self.maxMemoryCost    = 1024 * 1024 * 40    // 40 mb in memory
        self.maxCacheAge      = 60 * 60 * 24 * 7    // 1 week
    }
    
    override class func sharedImageCache() -> FSImageCache {
        struct Static {
            static var instance: FSImageCache?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FSImageCache(namespace: "fs_cache")
        }
        
        return Static.instance!
    }
    
    //MARK: - types helper
    func cacheKey(key: String, type: FSImageCacheType) -> String {
        return key + type.rawValue
    }
    
    func cacheImage(image: UIImage, type: FSImageCacheType) -> UIImage? {
        
        switch type {
        case .Original:
            return image
            
        case .Thumbnail:
            if image.size.width > self.thumbnailSize.width || image.size.height > self.thumbnailSize.height {
                let size = self.thumbnailSize
                if let _ = image.images {
                    return image.sd_animatedImageByScalingAndCroppingToSize(size)
                } else {
                    return image.fsCache_resizeProportionalRelativelyBigSide(size)
                }
            } else {
                return image
            }
            
        case .Blur where image.images == nil:
            return image.fsCache_applyBlurWithRadius(self.blurSetting.blurRadius, tintColor: self.blurSetting.tintColor, saturationDeltaFactor: self.blurSetting.saturationDeltaFactor)
            
        default:
            return nil
        }
    }
    
    //MARK: - private
    private func imageCacheHandler(type: FSImageCacheType) -> SDImageCache {
        if type == .Original {
            return SDImageCache.sharedImageCache()
        } else {
            return self
        }
    }
}

//MARK: - access to data by more type
extension FSImageCache {
    
    func storeImage(image: UIImage!, types: Set<FSImageCacheType> = FSImageCacheType.allTypes(), recalculateFromImage recalculate: Bool = true, imageData: NSData! = nil, forKey key: String, toDisk: Bool = true) {
        for type in types {
            let key = self.cacheKey(key, type: type)
            let image = self.cacheImage(image, type: type)
            let imageCacheHandler = self.imageCacheHandler(type)
            if imageCacheHandler == self {
                super.storeImage(image, recalculateFromImage: recalculate, imageData: imageData, forKey: key, toDisk: toDisk)
            } else {
                imageCacheHandler.storeImage(image, recalculateFromImage: recalculate, imageData: imageData, forKey: key, toDisk: toDisk)
            }
        }
    }
    
    func imageFromMemoryCacheForKey(key: String, types: Set<FSImageCacheType> = FSImageCacheType.allTypes()) -> [FSImageCacheType : UIImage?] {
        var result: [FSImageCacheType : UIImage?] = Dictionary()
        for type in types {
            result[type] = self.imageFromMemoryCacheForKey(key, type: type)
        }
        return result
    }
    
    func imageFromDiskCacheForKey(key: String, types: Set<FSImageCacheType> = FSImageCacheType.allTypes()) -> [FSImageCacheType : UIImage?] {
        var result: [FSImageCacheType : UIImage?] = Dictionary()
        for type in types {
            result[type] = self.imageFromDiskCacheForKey(key, type: type)
        }
        return result
    }
    
    func removeImageForKey(key: String, types: Set<FSImageCacheType> = FSImageCacheType.allTypes(), fromDisk: Bool = true, withCompletion completion: SDWebImageNoParamsBlock! = nil) {
        for type in types {
            self.removeImageForKey(key, type: type)
        }
    }
    
    func diskImageExistsWithKey(key: String, types: Set<FSImageCacheType> = FSImageCacheType.allTypes()) -> [FSImageCacheType : Bool] {
        var result: [FSImageCacheType : Bool] = Dictionary()
        for type in types {
            result[type] = self.diskImageExistsWithKey(key, type: type)
        }
        return result
    }
}


//MARK: - access to data by one type
extension FSImageCache {
    
    func queryDiskCacheForKey(key: String, type: FSImageCacheType, done doneBlock: SDWebImageQueryCompletedBlock? = nil) -> NSOperation! {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).queryDiskCacheForKey(key, done: doneBlock)
    }
    
    func imageFromMemoryCacheForKey(key: String, type: FSImageCacheType) -> UIImage? {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).imageFromMemoryCacheForKey(key)
    }
    
    func imageFromDiskCacheForKey(key: String, type: FSImageCacheType) -> UIImage? {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).imageFromDiskCacheForKey(key)
    }
    
    func removeImageForKey(key: String, type: FSImageCacheType, fromDisk: Bool = true, withCompletion completion: SDWebImageNoParamsBlock? = nil) {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).removeImageForKey(key, fromDisk: fromDisk, withCompletion: completion)
    }
    
    func diskImageExistsWithKey(key: String, type: FSImageCacheType) -> Bool {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).diskImageExistsWithKey(key)
    }
    
    func diskImageExistsWithKey(key: String, type: FSImageCacheType, completion completionBlock: SDWebImageCheckCacheCompletionBlock? = nil) {
        let key = self.cacheKey(key, type: type)
        return self.imageCacheHandler(type).diskImageExistsWithKey(key, completion: completionBlock)
    }
}

//MARK: - override
extension FSImageCache {
    
    //This code overrides the methods and necessary for proper preservation of data. DO NOT TOUCH!
    override func storeImage(image: UIImage, recalculateFromImage recalculate: Bool, imageData: NSData?, forKey key: String, toDisk: Bool) {
        self.storeImage(image, types: FSImageCacheType.allTypes(), recalculateFromImage: recalculate, imageData: nil, forKey: key, toDisk: toDisk)
    }
    
    override func queryDiskCacheForKey(key: String, done doneBlock: SDWebImageQueryCompletedBlock!) -> NSOperation! {
        return self.queryDiskCacheForKey(key, type: .Original, done: doneBlock)
    }
    
    //MARK: - removing data
    override func clearDisk() {
        super.clearDisk()
        SDImageCache.sharedImageCache().clearDisk()
    }
    
    override func cleanDiskWithCompletionBlock(completionBlock: SDWebImageNoParamsBlock? = nil) {
        var countOfOperations = 2
        let completionHandler = {
            countOfOperations--
            if countOfOperations == 0 {
               completionBlock?()
            }
        }
        
        super.cleanDiskWithCompletionBlock { () -> Void in
            completionHandler()
        }
        
        SDImageCache.sharedImageCache().cleanDiskWithCompletionBlock { () -> Void in
            completionHandler()
        }
    }
    
    override func clearDiskOnCompletion(completion: SDWebImageNoParamsBlock? = nil) {
        var countOfOperations = 2
        let completionHandler = {
            countOfOperations--
            if countOfOperations == 0 {
                completion?()
            }
        }
        
        super.clearDiskOnCompletion { () -> Void in
            completionHandler()
        }
        
        SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
            completionHandler()
        }
    }
    
    override func cleanDisk() {
        super.cleanDisk()
        SDImageCache.sharedImageCache().clearDisk()
    }
    
    override func clearMemory() {
        super.clearMemory()
        SDImageCache.sharedImageCache().clearMemory()
    }
}

