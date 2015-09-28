//
//  APIManager.swift
//  AFNetworkingExample
//
//  Created by Vladimir Goncharov on 06.08.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

import UIKit

//MARK: -

typealias ResponseDictionary = Dictionary<String, AnyObject>
typealias ResponseArrayOfDictionaries = Array<ResponseDictionary>

private let APIManagerSharedInstance: APIManager = APIManager()
class APIManager {
    
    static var manager: APIManager {
        return APIManagerSharedInstance
    }
    
    //MARK: - lazy
    private(set) lazy var baseURL : NSURL = {
        let baseURL = NSURL(string: "http://localhost:8888/requests/")!
        return baseURL
    }()
    
    private(set) lazy var operationManagerJSON: AFHTTPRequestOperationManager = {
        
        let operationManager                    = AFHTTPRequestOperationManager(baseURL: self.baseURL)
        operationManager.requestSerializer      = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.PrettyPrinted)
        operationManager.responseSerializer     = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        
        return operationManager
    }()
    
    private(set) lazy var operationManagerXML: AFHTTPRequestOperationManager = {
        
        let operationManager                    = AFHTTPRequestOperationManager(baseURL: self.baseURL)
        operationManager.requestSerializer      = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.PrettyPrinted)
        operationManager.responseSerializer     = AFXMLParserResponseSerializer()
        
        return operationManager
    }()
    
    private(set) lazy var operationManagerXMLCustom: AFHTTPRequestOperationManager = {
        
        let operationManager                    = AFHTTPRequestOperationManager(baseURL: self.baseURL)
        operationManager.requestSerializer      = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.PrettyPrinted)
        operationManager.responseSerializer     = FSXMLResponseSerializer(XMLReaderOptions: 0)
        
        return operationManager
    }()
    
    //MIME types
    class func MIMEType(fileName: String) -> String {
        let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (fileName as NSString).pathExtension, nil)!
        let str = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType)!
        
        return (str.takeUnretainedValue() as String) ?? "application/octet-stream"
    }
}


//MARK: - Object
extension AFHTTPRequestOperationManager {

    func OBJECT_GET(parameters: Dictionary<String, AnyObject>?, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
        
        let operation =
        self.GET("object.php", parameters: parameters, success: success) { (operation, error) -> Void in
            
            let errorHandler = ErrorHandler(failureRequestOperation: operation)
            errorHandler.customErrorHandler = {(operation, error) -> String? in

                switch (operation.response.statusCode)
                {
                case 422:
                    return operation.responseString

                default:
                    return nil
                }
            }
            
            let errorData = errorHandler.errorData()
            failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
        }
        
        return operation
    }
}


//MARK: - Image
extension AFHTTPRequestOperationManager {
    
    func IMAGE_GET(parameters: Dictionary<String, AnyObject>?, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
        
        let operation =
        self.GET("image.php", parameters: parameters, success: success) { (operation, error) -> Void in
            
            let errorHandler = ErrorHandler(failureRequestOperation: operation)
            errorHandler.customErrorHandler = {(operation, error) -> String? in
                
                switch (operation.response.statusCode)
                {
                case 422:
                    return operation.responseString
                    
                default:
                    return nil
                }
            }
            
            let errorData = errorHandler.errorData()
            failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
        }
        
        return operation
    }
    
    func IMAGE_POST(parameters: Dictionary<String, AnyObject>?, constructingBodyWithBlock: ((multipartFormData: AFMultipartFormData!) -> Void)!, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
        
        let operation =
        self.POST("image.php", parameters: parameters, constructingBodyWithBlock: constructingBodyWithBlock, success: success) { (operation, error) -> Void in
            
            let errorHandler = ErrorHandler(failureRequestOperation: operation)
            errorHandler.customErrorHandler = {(operation, error) -> String? in
                
                return operation.responseString
            }

            let errorData = errorHandler.errorData()
            failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
        }
        
        return operation
    }
    
    func IMAGE_PATCH(parameters: Dictionary<String, AnyObject>?, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
        
        let operation =
        self.PATCH("image.php", parameters: parameters, success: success) { (operation, error) -> Void in
            
            let errorHandler = ErrorHandler(failureRequestOperation: operation)
            errorHandler.customErrorHandler = {(operation, error) -> String? in
                
                return operation.responseString
            }

            let errorData = errorHandler.errorData()
            failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
        }
        
        return operation
    }
    
    func IMAGE_DELETE(parameters: Dictionary<String, AnyObject>?, success: ((operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation? {
        
        let operation =
        self.DELETE("image.php", parameters: parameters, success: success) { (operation, error) -> Void in
            
            let errorHandler = ErrorHandler(failureRequestOperation: operation)
            errorHandler.customErrorHandler = {(operation, error) -> String? in
                
                return operation.responseString
            }

            let errorData = errorHandler.errorData()
            failure?(operation: operation, errorDescription: errorData.description, errorType: errorData.type, isCancelled: errorHandler.isCancelled)
        }
        
        return operation
    }
}

