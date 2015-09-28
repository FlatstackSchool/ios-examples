import UIKit

//MARK: - CoreData helper
extension NSManagedObject {
    
    class func serializationArray(items: [AnyObject], sync: Bool = true, updateObjectsIfNeed:((objects: [NSManagedObject]) -> Void)? = nil, completion: ((result: [NSManagedObject]) -> Void)?, failure:((error: NSError?) -> Void)?) -> Void {
        
        var objects: [NSManagedObject]! = nil
        
        let finishClosure = {(contextDidSave: Bool, error: NSError?) -> Void in
            
            if contextDidSave == true {
                var result:[NSManagedObject] = []
                if let lObjects = objects {
                    for object in lObjects {
                        result.append(object.MR_inContext(NSManagedObjectContext.MR_defaultContext()))
                    }
                }
                completion?(result: result)
            } else {
                failure?(error: error)
            }
        }
        
        if sync == true {
            
            let syncSaveHandler = {() -> Void in
                MagicalRecord.saveWithBlockAndWait({ (context) -> Void in
                    objects = self.MR_importFromArray(items, inContext: context) as! [NSManagedObject]
                    updateObjectsIfNeed?(objects: objects)
                })
                
                finishClosure(true, nil)
            }
            
            if NSThread.isMainThread() {
                syncSaveHandler()
            } else {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    syncSaveHandler()
                })
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MagicalRecord.saveWithBlock({ (context) -> Void in
                    objects = self.MR_importFromArray(items, inContext: context) as! [NSManagedObject]
                    updateObjectsIfNeed?(objects: objects)
                    }, completion: { (contextDidSave, error) -> Void in
                        finishClosure(contextDidSave, error)
                })
            })
        }
    }
    
    class func serializationObject(item: AnyObject, sync: Bool = true, updateObjectIfNeed:((object: NSManagedObject) -> Void)? = nil, completion: ((result: NSManagedObject) -> Void)?, failure:((error: NSError?) -> Void)?) -> Void {
        
        var object: NSManagedObject! = nil
        
        let finishClosure = {(contextDidSave: Bool, error: NSError?) -> Void in
            
            if contextDidSave == true {
                let result = object!.MR_inContext(NSManagedObjectContext.MR_defaultContext())
                completion?(result: result)
            } else {
                failure?(error: error)
            }
        }
        
        if sync == true {
            
            let syncSaveHandler = {() -> Void in
                MagicalRecord.saveWithBlockAndWait({ (context) -> Void in
                    object = self.MR_importFromObject(item, inContext: context)
                    updateObjectIfNeed?(object: object)
                })
                
                finishClosure(true, nil)
            }
            
            if NSThread.isMainThread() {
                syncSaveHandler()
            } else {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    syncSaveHandler()
                })
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MagicalRecord.saveWithBlock({ (context) -> Void in
                    object = self.MR_importFromObject(item, inContext: context)
                    updateObjectIfNeed?(object: object)
                    }, completion: { (contextDidSave, error) -> Void in
                        finishClosure(contextDidSave, error)
                })
            })
        }
    }
}

//MARK: - FS style serialization
extension NSManagedObject {
    
    struct FSSerializationInputParamaters {
        let operation: AFHTTPRequestOperation
        let responseObject: ResponseDictionary
        let firstKey: String
        let sync: Bool
        
        init(operation: AFHTTPRequestOperation, responseObject: ResponseDictionary, firstKey: String, sync: Bool = true) {
            self.operation = operation
            self.responseObject = responseObject
            self.firstKey = firstKey
            self.sync = sync
        }
    }
    
    class func fs_serializationArray(inputParams: FSSerializationInputParamaters, updateObjectsIfNeed:((objects: [NSManagedObject]) -> Void)? = nil, success: ((operation: AFHTTPRequestOperation!, objects: [NSManagedObject]) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> Void {
        
        if let JSON = inputParams.responseObject[inputParams.firstKey] as? ResponseArrayOfDictionaries {
            self.serializationArray(JSON, sync: inputParams.sync, updateObjectsIfNeed: updateObjectsIfNeed, completion: { (result) -> Void in
                success?(operation: inputParams.operation, objects:result)
                }, failure: { (error) -> Void in
                    failure?(operation: inputParams.operation, errorDescription: error?.localizedDescription, errorType: ErrorType.CoreData, isCancelled: false)
            })
        } else {
            failure?(operation: inputParams.operation, errorDescription: "Result by key \(inputParams.firstKey) not found", errorType: ErrorType.MissingParameter, isCancelled: false)
        }
    }
    
    class func fs_serializationObject(inputParams: FSSerializationInputParamaters, updateObjectIfNeed:((object: NSManagedObject) -> Void)? = nil, success: ((operation: AFHTTPRequestOperation!, object: NSManagedObject) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> Void {
        
        if let JSON = inputParams.responseObject[inputParams.firstKey] as? ResponseDictionary {
            self.serializationObject(JSON, sync: inputParams.sync, updateObjectIfNeed: updateObjectIfNeed,  completion: { (result) -> Void in
                success?(operation: inputParams.operation, object: result)
                }, failure: { (error) -> Void in
                    failure?(operation: inputParams.operation, errorDescription: error?.localizedDescription, errorType: ErrorType.CoreData, isCancelled: false)
            })
        } else {
            failure?(operation: inputParams.operation, errorDescription: "Result by key \(inputParams.firstKey) not found", errorType: ErrorType.MissingParameter, isCancelled: false)
        }
    }
}
