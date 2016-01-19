@objc(AFImage)
class AFImage: _AFImage {

    //MARK: - import data
    override func shouldImport(data: AnyObject!) -> Bool {
        return true
    }
    
    override func willImport(data: AnyObject!) {
        let jsonDictionary = data as! Dictionary <String, AnyObject>
        if let serverID = jsonDictionary["id"] as? Int {
            self.serverID = serverID
        }
    }
    
    override func didImport(data: AnyObject!) {
        self.update(data as! Dictionary <String, AnyObject>)
    }
    
    //MARK: - update
    func update(jsonDictionary: Dictionary <String, AnyObject>) {
        if let filename = jsonDictionary["filename"] as? String {
            self.name = filename
        }
        if let mime = jsonDictionary["filetype"] as? String {
            self.mime = mime
        }
        if let data = jsonDictionary["data"] as? String {
            if let data = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                self.image = UIImage(data: data)
            }
        }
    }
}

//Equatable Protocol
func == (lhs: AFImage, rhs: AFImage) -> Bool {
    if let lServerID = lhs.serverID?.integerValue, let rServerID = rhs.serverID?.integerValue where lServerID >= 0 && rServerID >= 0 {
        return lServerID == rServerID
    }
    return lhs.objectID.URIRepresentation() == rhs.objectID.URIRepresentation()
}

extension AFImage {
    
    class func IMAGE_GET(id: Int, success: ((operation: AFHTTPRequestOperation!, object: AFImage!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        let parameters = ["id" : id]
        
        let operation =
        APIManager.manager.operationManagerJSON.IMAGE_GET(parameters, success: { (operation, responseObject) -> Void in
                
            let inputParams = FSSerializationInputParamaters(operation: operation!, responseObject: responseObject as! ResponseDictionary, firstKey: "image")
            AFImage.fs_serializationObject(inputParams, success: { (operation, object) -> Void in
                success?(operation: operation, object: object as! AFImage)
                }, failure: failure)
            
        }, failure: failure)
        
        return operation
    }
    
    class func IMAGE_POST(image: NSData, name: String, success: ((operation: AFHTTPRequestOperation!, object: AFImage!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        let parameters: Dictionary<String, AnyObject> = ["name" : name]
        
        let operation =
        APIManager.manager.operationManagerJSON.IMAGE_POST(parameters, constructingBodyWithBlock: { (multipartFormData: AFMultipartFormData!) -> Void in
            
            multipartFormData.appendPartWithFileData(image, name: "image", fileName: name, mimeType: APIManager.MIMEType(name))
            
            }, success: { (operation, responseObject) -> Void in
                
                let inputParams = FSSerializationInputParamaters(operation: operation!, responseObject: responseObject as! ResponseDictionary, firstKey: "image")
                AFImage.fs_serializationObject(inputParams, success: { (operation, object) -> Void in
                    success?(operation: operation, object: object as! AFImage)
                }, failure: failure)

            }, failure: failure)
        
        return operation
    }
    
    func IMAGE_PATCH(image: NSData?, name: String?, success: ((operation: AFHTTPRequestOperation!, object: AFImage!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        var parameters: Dictionary<String, AnyObject> = ["id" : self.serverID!.integerValue]
        
        if let lName = name {
            parameters["name"] = lName
        }
        if let lImage = image {
            parameters["image"] = lImage.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        
        let operation =
        APIManager.manager.operationManagerJSON.IMAGE_PATCH(parameters, success: { (operation, responseObject) -> Void in
                
            let inputParams = FSSerializationInputParamaters(operation: operation!, responseObject: responseObject as! ResponseDictionary, firstKey: "image")
            AFImage.fs_serializationObject(inputParams, success: { (operation, object) -> Void in
                success?(operation: operation, object: object as! AFImage)
                }, failure: failure)
            
        }, failure: failure)
        
        return operation
    }
    
    func IMAGE_DELETE(success: ((operation: AFHTTPRequestOperation!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        let parameters: Dictionary<String, AnyObject> = ["id" : self.serverID!.integerValue]

        let operation =
        APIManager.manager.operationManagerJSON.IMAGE_DELETE(parameters, success: { (operation, responseObject) -> Void in
            
            success?(operation: operation)
            
        }, failure: failure)
        
        return operation
    }
}
