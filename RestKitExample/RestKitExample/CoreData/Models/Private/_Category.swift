// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Category.swift instead.

import CoreData

enum CategoryAttributes: String {
    case name = "name"
}

enum CategoryRelationships: String {
    case calendars = "calendars"
}

@objc
class _Category: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Category"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Category.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var calendars: NSSet

    func calendarsSet() -> NSMutableSet {
        return self.calendars.mutableCopy() as! NSMutableSet
    }

}

extension _Category {

    func addCalendars(objects: NSSet) {
        let mutable = self.calendars.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.calendars = mutable.copy() as! NSSet
    }

    func removeCalendars(objects: NSSet) {
        let mutable = self.calendars.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.calendars = mutable.copy() as! NSSet
    }

    func addCalendarsObject(value: Calendar!) {
        let mutable = self.calendars.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.calendars = mutable.copy() as! NSSet
    }

    func removeCalendarsObject(value: Calendar!) {
        let mutable = self.calendars.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.calendars = mutable.copy() as! NSSet
    }

}
