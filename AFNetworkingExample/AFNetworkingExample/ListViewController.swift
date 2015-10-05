//
//  ListViewController.swift
//  AFNetworkingExample
//
//  Created by Vladimir Goncharov on 21.08.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    private enum Section : Int {
        case Serialization = 0
        case Image
        
        var countOfRows : Int {
            switch self {
            case Serialization:
                return 4
                
            case Image:
                return 8
            }
        }
        
        private enum SerializationRow : Int {
            case JSON = 0
            case XML
            case FSXML
            case Broken
            
            static func title() -> String {
                return "Type of serializations"
            }
            
            var text : String {
                switch self {
                case .JSON:
                    return "JSON"
                    
                case .XML:
                    return "XML"
                    
                case .FSXML:
                    return "FS XML"
                    
                case .Broken:
                    return "Broken request"
                }
            }
        }
        
        private enum ImageRow : Int {
            case GET = 0
            case GETBroken
            case POST
            case POSTBroken
            case PATCH
            case PATCHBroken
            case DELETE
            case DELETEBroken
            
            static func title() -> String {
                return "Type of requests"
            }
            
            var text : String {
                switch self {
                case .GET:
                    return "GET Image"
                    
                case .GETBroken:
                    return "TRY GET (broken)"
                    
                case .POST:
                    return "POST Image"
                    
                case .POSTBroken:
                    return "TRY POST (broken)"
                    
                case .PATCH:
                    return "PATCH Image"
                    
                case .PATCHBroken:
                    return "TRY PATCH (broken)"
                    
                case .DELETE:
                    return "DELETE Image"
                    
                case .DELETEBroken:
                    return "TRY DELETE (broken)"
                }
            }
        }
    }
    
    private enum CellIdentifier : String {
        case Cell = "cell"
    }
    
    //MARK: - UI
    
    @IBOutlet weak var textFiled: UITextField!
    
    var imageID: Int {
        if let text = self.textFiled.text, let value = Int(text) {
            return value
        } else {
            return -1
        }
    }
    
    //MARK: - GET type request
    func performGetJSONRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFObject.GET_OBJECT(AFObject.TypeParameter.JSON, success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performGetXMLRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFObject.GET_OBJECT(AFObject.TypeParameter.XML, success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performGetFSXMLRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFObject.GET_OBJECT(AFObject.TypeParameter.XML, success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performBrokenGetRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        APIManager.manager.operationManagerJSON.OBJECT_GET(nil, success: nil) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
            self?.presentAlertViewWithError(errorDescription)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    //MARK: - Image
    
    func performGetImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFImage.IMAGE_GET(self.imageID, success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performBrokenGetImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFImage.IMAGE_GET(99999999, success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performPostImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        AFImage.IMAGE_POST(UIImagePNGRepresentation(UIImage(named: "test_image")!)!, name: "\(NSProcessInfo.processInfo().globallyUniqueString).png", success: {[weak self] (operation, object) -> Void in
            self?.presentResultWithSucceeded(object)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                self?.presentAlertViewWithError(errorDescription)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performBrokenPostImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        APIManager.manager.operationManagerJSON.IMAGE_POST(nil, constructingBodyWithBlock: nil, success: nil) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
            
            self?.presentAlertViewWithError(errorDescription)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performPatchImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if let image = AFImage.MR_findFirstWithPredicate(NSPredicate(format: "SELF.%K == %@", argumentArray: [AFImageAttributes.serverID.rawValue, self.imageID]), inContext: NSManagedObjectContext.MR_defaultContext()) {
            
            image.IMAGE_PATCH(UIImagePNGRepresentation(UIImage(named: "patch_test_image")!), name: "\(NSProcessInfo.processInfo().globallyUniqueString).png", success: {[weak self] (operation, object) -> Void in
                self?.presentResultWithSucceeded(object)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                    self?.presentAlertViewWithError(errorDescription)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        } else {
            self.presentAlertViewWithError("Local AFImage with ID=\(self.imageID) not found")
        }
    }
    
    func performBrokenPatchImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        APIManager.manager.operationManagerJSON.IMAGE_PATCH(nil, success: nil) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
            
            self?.presentAlertViewWithError(errorDescription)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func performDeleteImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if let image = AFImage.MR_findFirstWithPredicate(NSPredicate(format: "SELF.%K == %@", argumentArray: [AFImageAttributes.serverID.rawValue, self.imageID]), inContext: NSManagedObjectContext.MR_defaultContext()) {
            
            image.IMAGE_DELETE({ (operation) -> Void in
                UIAlertView(title: "Ooooops!", message: "Image has been deleted", delegate: nil, cancelButtonTitle: "ОК").show()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
                    self?.presentAlertViewWithError(errorDescription)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        } else {
            self.presentAlertViewWithError("Local AFImage with ID=\(self.imageID) not found")
        }
    }
    
    func performDeleteBrokenImageRequest() -> Void {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        APIManager.manager.operationManagerJSON.IMAGE_DELETE(nil, success: nil) {[weak self] (operation, errorDescription, errorType, isCancelled) -> Void in
            
            self?.presentAlertViewWithError(errorDescription)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    //MARK: - UI helper
    private func presentResultWithSucceeded(object: AnyObject!) -> Void {
        self.performSegueWithIdentifier("result", sender: object)
    }
    
    private func presentAlertViewWithError(errorDescription: String!) -> Void {
        UIAlertView(title: "Ooooops!", message: errorDescription, delegate: nil, cancelButtonTitle: "ОК").show()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! ResultViewController
        destinationViewController.result = sender
    }
}

//MARK: - UITableViewDelegate
extension ListViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .Serialization:
            switch Section.SerializationRow(rawValue: indexPath.row)! {
            case .JSON:
                self.performGetJSONRequest()
                
            case .XML:
                self.performGetXMLRequest()
                
            case .FSXML:
                self.performGetFSXMLRequest()
                
            case .Broken:
                self.performBrokenGetRequest()
            }
            
        case .Image:
            switch Section.ImageRow(rawValue: indexPath.row)! {
            case .GET:
                self.performGetImageRequest()
                
            case .GETBroken:
                self.performBrokenGetImageRequest()
                
            case .POST:
                self.performPostImageRequest()
                
            case .POSTBroken:
                self.performBrokenPostImageRequest()
                
            case .PATCH:
                self.performPatchImageRequest()
                
            case .PATCHBroken:
                self.performBrokenPatchImageRequest()
                
            case .DELETE:
                self.performDeleteImageRequest()
                
            case .DELETEBroken:
                self.performDeleteBrokenImageRequest()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ListViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)!.countOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Cell.rawValue)!
        
        switch Section(rawValue: indexPath.section)! {
        case .Serialization:
            cell.textLabel?.text = Section.SerializationRow(rawValue: indexPath.row)!.text
            
        case .Image:
            cell.textLabel?.text = Section.ImageRow(rawValue: indexPath.row)!.text
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Serialization:
            return Section.SerializationRow.title()
            
        case .Image:
            return Section.ImageRow.title()
        }
    }
}



