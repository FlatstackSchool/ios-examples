//
//  UIImageResizes.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 10.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

public extension UIImage {
    
    public func fsCache_resize(size: CGSize) -> UIImage? {
        
        let selfImageRef = self.CGImage
        var selfBitmapInfo = CGImageGetBitmapInfo(selfImageRef)
        if (selfBitmapInfo.rawValue == CGImageAlphaInfo.None.rawValue) {
            selfBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.NoneSkipLast.rawValue)
        }
        
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(selfImageRef), 0, CGImageGetColorSpace(selfImageRef), selfBitmapInfo.rawValue)
        CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height))
        
        switch self.imageOrientation
        {
        case .Up, .UpMirrored:
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), selfImageRef)
            
        case .Left, .LeftMirrored:
            CGContextRotateCTM(context, CGFloat(M_PI_2))
            CGContextTranslateCTM(context, 0.0, -size.width)
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), selfImageRef)
            
        case .Right, .RightMirrored:
            CGContextRotateCTM(context, CGFloat(-M_PI_2))
            CGContextTranslateCTM(context, -size.height, 0.0)
            CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), selfImageRef)
            
        case .Down, .DownMirrored:
            CGContextRotateCTM(context, CGFloat(M_PI));
            CGContextTranslateCTM(context, -size.width, -size.height)
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), selfImageRef)
        }
        
        if let scaledImage = CGBitmapContextCreateImage(context) {
            return UIImage(CGImage: scaledImage)
        }
        
        return nil
    }
    
    public func fsCache_resizeProportionalRelativelySmallSide(size: CGSize) -> UIImage! {
        return self.fsCache_resize(self.fsCache_sizeProportionalRelativelySmallSide(size))
    }
    
    public func fsCache_resizeProportionalRelativelyBigSide(size: CGSize) -> UIImage! {
        return self.fsCache_resize(self.fsCache_sizeProportionalRelativelyBigSide(size))
    }
    
    public func fsCache_sizeProportionalRelativelySmallSide(size: CGSize) -> CGSize {
        var result = CGSizeZero
        if (self.size.width > self.size.height) {
            result = CGSizeMake((self.size.width/self.size.height) * size.height, size.height);
        } else {
            result = CGSizeMake(size.width, (self.size.height/self.size.width) * size.width);
        }
        return result
    }
    
    public func fsCache_sizeProportionalRelativelyBigSide(size: CGSize) -> CGSize {
        var result = CGSizeZero
        if (self.size.width < self.size.height) {
            result = CGSizeMake((self.size.width/self.size.height) * size.height, size.height);
        } else {
            result = CGSizeMake(size.width, (self.size.height/self.size.width) * size.width);
        }
        return result
    }
}