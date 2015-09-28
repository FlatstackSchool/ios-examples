//
//  ErrorHandler.swift
//  Rubin
//
//  Created by Vladimir Goncharov on 26.11.14.
//  Copyright (c) 2014 Flatstack. All rights reserved.
//

import UIKit

enum ErrorType {
    
    //MARK: - problem with connection
    case NoInternetConnection
    case ServerNotRespond
    
    //MARK: - request error
    case Unauthorized401
    case NotFound404
    case UnprocessableEntity422
    
    //MARK: - application error
    case MissingParameter
    case CoreData
    case ParsingData
    
    //MARK: - other 
    case Custom
    case NotDetermined
}

class ErrorHandler {
    //MARK: - accessory
    let requestOperation: AFHTTPRequestOperation
    var customErrorHandler: ((requestOperation: AFHTTPRequestOperation!, error: NSError!) -> String?)?
    
    //MARK: - init
    init(failureRequestOperation: AFHTTPRequestOperation) {
        self.requestOperation   = failureRequestOperation
    }
    
    //MARK: - 
    var isCancelled : Bool {
        return self.requestOperation.cancelled
    }
    
    func errorData() -> (description: String, type: ErrorType) {
        
        if  AFNetworkReachabilityManager.sharedManager().reachable == false &&
            AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus != .Unknown {
                
            return ("Please check your internet connection", .NoInternetConnection)
        }
        
        if let response = self.requestOperation.response {
            
            //https://flatstack.atlassian.net/wiki/display/DEV/REST+API+design
            //Here can be found Flatstack format of errors
            
            switch (response.statusCode)
            {
            case 401:
                return ("Unauthorized request. Please try logout and login again.", .Unauthorized401)
                
            case 404:
                return ("Something went wrong and you were not there.", .NotFound404)
                
            case 422:
                if let responseData = self.requestOperation.responseData {
                    
                    do {
                        if let error = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments) as? ResponseDictionary, let errorDescriptionJSON = error["error"] as? ResponseDictionary, let errorStringJSON = errorDescriptionJSON["error"] as? String {
                            
                            var fullErrorDescription = "\(errorStringJSON)"
                            
                            if let validationsJSON = errorDescriptionJSON["validations"] as? ResponseDictionary {
                                fullErrorDescription += "\n\n"
                                for (validationKey, validationValue) in validationsJSON {
                                    fullErrorDescription += "\(validationKey) - \(validationValue) \n"
                                }
                            }
                            
                            return (fullErrorDescription, .UnprocessableEntity422)
                        }
                        
                    } catch let error as NSError {
                        return (error.localizedDescription, .ParsingData)
                    }
                }
                
            default:
                break
            }
            
            if let lDescription = self.customErrorHandler?(requestOperation: self.requestOperation, error: self.requestOperation.error) where lDescription.characters.count > 0 {
                return (lDescription, .Custom)
            } else {
                return ("Please contact with developers for resolving this issue.", .NotDetermined)
            }
        } else {
            return ("Unfortunately, the server does not respond. Please try again later.", .ServerNotRespond)
        }
    }
}


