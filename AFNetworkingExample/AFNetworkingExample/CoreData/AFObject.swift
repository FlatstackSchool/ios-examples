let kLocalID: Int = -1;  // exist only on client

@objc(AFObject)
class AFObject: _AFObject {
    
    override func awakeFromInsert() {
        
        self.createdAt = NSDate()
        self.updatedAt = NSDate()
        self.serverID = kLocalID
        
        super.awakeFromInsert()
    }
    
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
    
    func update(jsonDictionary: Dictionary <String, AnyObject>) {
        if let attributes = jsonDictionary["attributes"] as? ResponseDictionary {
            self.attributes = attributes
        }
    }
    
    //MARK: - functions
    func isLocalObject() -> Bool {
        return self.serverID == kLocalID
    }
}

//MARK: - API
extension AFObject {
    
    enum TypeParameter {
        case JSON
        case XML
        case XMLCustom
        
        var operationManager : AFHTTPRequestOperationManager? {
            switch self {
            case .JSON :
                return APIManager.manager.operationManagerJSON
                
            case .XML :
                return APIManager.manager.operationManagerXML
                
            case .XMLCustom :
                return APIManager.manager.operationManagerXMLCustom
            }
        }
        
        var parameter : String! {
            switch self {
            case .JSON :
                return "json"
                
            case .XML, .XMLCustom :
                return "xml"
            }
        }
    }
    
    class func GET_OBJECT(type: TypeParameter, success: ((operation: AFHTTPRequestOperation!, object: AFObject!) -> Void)?, failure: ((operation: AFHTTPRequestOperation!, errorDescription: String!, errorType: ErrorType!, isCancelled: Bool) -> Void)?) -> AFHTTPRequestOperation?
    {
        let operationManager = type.operationManager!
        
        let parameters = ["type" : type.parameter]
        
        let operation =
        operationManager.OBJECT_GET(parameters, success: { (operation, responseObject) -> Void in
            
            var responseObjectUpdated: ResponseDictionary! = nil
            if let lResponseObject = responseObject as? ResponseDictionary {
                responseObjectUpdated = lResponseObject
                //if we using AFXMLParserResponseSerializer
            } else if let lResponseObject = responseObject as? NSXMLParser {
                let error: NSError? = nil
                responseObjectUpdated = (try! XMLReader.dictionaryForNSXMLParser(lResponseObject, options: UInt(XMLReaderOptionsResolveExternalEntities))) as! ResponseDictionary
                
                if let lError = error {
                    failure?(operation: operation, errorDescription: lError.localizedDescription, errorType: .Custom, isCancelled: false)
                    return
                }
            }
            let inputParams = FSSerializationInputParamaters(operation: operation!, responseObject: responseObjectUpdated, firstKey: "object")
            AFObject.fs_serializationObject(inputParams, success: { (operation, object) -> Void in
                success?(operation: operation, object: object as! AFObject)
            }, failure: failure)

        }, failure: failure)
        
        return operation
    }
}

//Equatable Protocol
func == (lhs: AFObject, rhs: AFObject) -> Bool {
    if let lServerID = lhs.serverID?.integerValue, let rServerID = rhs.serverID?.integerValue where lServerID >= 0 && rServerID >= 0 {
        return lServerID == rServerID
    }
    return lhs.objectID.URIRepresentation() == rhs.objectID.URIRepresentation()
}
