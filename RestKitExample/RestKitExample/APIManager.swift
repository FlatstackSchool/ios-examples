//
//  APIManager.swift
//  RestKitExample
//
//  Created by Vladimir Goncharov on 29.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

let manager = RKObjectManager.init(baseURL: NSURL.init(string: "https://web-app.usc.edu/web/eo4/apix"))

class ErrorHandler: NSObject {
    
    var reason: String?
}