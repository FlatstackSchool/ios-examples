import UIKit

class ValueTransformer: NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.classForCoder()
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        
        return NSKeyedArchiver.archivedDataWithRootObject(value!)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithData(value as! NSData)
    }    
}