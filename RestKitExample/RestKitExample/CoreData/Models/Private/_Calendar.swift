// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Calendar.swift instead.

import CoreData

enum CalendarAttributes: String {
    case detailDescription = "detailDescription"
    case id = "id"
    case name = "name"
}

enum CalendarRelationships: String {
    case categories = "categories"
}

@objc
class _Calendar: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Calendar"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Calendar.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var detailDescription: String?

    // func validateDetailDescription(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var id: String?

    // func validateId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var categories: NSOrderedSet

    func categoriesSet() -> NSMutableOrderedSet {
        return self.categories.mutableCopy() as! NSMutableOrderedSet
    }

}

extension _Calendar {

    func addCategories(objects: NSOrderedSet) {
        let mutable = self.categories.mutableCopy() as! NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.categories = mutable.copy() as! NSOrderedSet
    }

    func removeCategories(objects: NSOrderedSet) {
        let mutable = self.categories.mutableCopy() as! NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.categories = mutable.copy() as! NSOrderedSet
    }

    func addCategoriesObject(value: Category!) {
        let mutable = self.categories.mutableCopy() as! NSMutableOrderedSet
        mutable.addObject(value)
        self.categories = mutable.copy() as! NSOrderedSet
    }

    func removeCategoriesObject(value: Category!) {
        let mutable = self.categories.mutableCopy() as! NSMutableOrderedSet
        mutable.removeObject(value)
        self.categories = mutable.copy() as! NSOrderedSet
    }

}
