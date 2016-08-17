//
//  Constants.swift
//  Ad-Examples
//
//  Created by Kruperfone on 02.10.14.
//  Copyright (c) 2014 Flatstack. All rights reserved.
//

import UIKit

enum GoogleBanners: Int {
    case BottomBanner = 0
    case BigBanner
    case Fullscreen
    
    var identifier: String {
        switch self {
        case .BottomBanner  : return "ca-app-pub-2189065656447965/6990169337"
        case .BigBanner     : return "ca-app-pub-2189065656447965/9804034936"
        case .Fullscreen    : return "ca-app-pub-2189065656447965/3419424139"
        }
    }
}

enum FacebookBanners: Int {
    case BottomBanner = 0
    case BigBanner
    case Fullscreen
    case Native
    
    var identifier: String {
        switch self {
        case .BottomBanner  : return "1079967798742656_1099044763501626"
        case .BigBanner     : return "1079967798742656_1105148289557940"
        case .Fullscreen    : return "1079967798742656_1099045353501567"
        case .Native        : return "1079967798742656_1105967662809336"
        }
    }
}

let TestDevices: [String] = ["dbc8105318ec88eb2ad7e1f1213acda826305d66"]

/*----------API keys---------*/
//For API Keys use prefix ABKeyAPI where AB is capital letters of your project name
//For example: 'SBKeyAPIMock' for Ad-Examples

/*--------------User Defaults keys-------------*/
let SBKeyUserDefaultsDeviceTokenData    = "kUserDefaultsDeviceTokenData"
let SBKeyUserDefaultsDeviceTokenString  = "kUserDefaultsDeviceTokenString"

/*----------Notifications---------*/
//For Notifications use prefix ABNotif where AB is capital letters of your project name
//For example: 'SBNotifMock' for Ad-Examples

/*--------------Fonts-------------*/

//Example of custom font family name
enum AppFont: Int {
    case Regular = 0
    case Bold
    case Italic
    
    static var allValues: [AppFont] {
        var fonts: [AppFont] = []
        var i = 0
        while let font = AppFont(rawValue: i) {
            fonts.append(font)
            i += 1
        }
        return fonts
    }
    
    static let familyName = "FontFamilyName"
    var familyName: String {return AppFont.familyName}
    
    var description : String {
        switch self {
        case .Regular:  return "FontFamilyName-Regular";
        case .Bold:     return "FontFamilyName-Bold";
        case .Italic:   return "FontFamilyName-Italic";
        }
    }
    
    func font (size:CGFloat) -> UIFont? {
        switch self {
        case .Regular:  return UIFont(name: self.description, size: size)
        case .Bold:     return UIFont(name: self.description, size: size)
        case .Italic:   return UIFont(name: self.description, size: size)
        }
    }
}

/*----------Colors----------*/

//Example of custom color schemes in application
let AppColor              = UIColor.clearColor()
