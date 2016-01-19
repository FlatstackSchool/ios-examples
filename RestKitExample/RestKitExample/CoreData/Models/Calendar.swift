@objc(Calendar)
class Calendar: _Calendar {

	// Custom logic goes here.

}

//MARK: - API
extension Calendar {
    
    class func API_getListOfCalendar(
        success:((operation: RKObjectRequestOperation!, mappingResult: RKMappingResult!) -> Void)?,
        failure:((operation: RKObjectRequestOperation!, error: NSError!) -> Void)?)
        -> RKManagedObjectRequestOperation? {
        
            let managedObjectStore = RKManagedObjectStore.defaultStore()
            
            //mapping for calendars
            let calendarMapping = RKEntityMapping.init(forEntityForName: Calendar.entityName(), inManagedObjectStore: managedObjectStore)
            calendarMapping.identificationAttributes = [CalendarAttributes.id.rawValue]
                calendarMapping.addAttributeMappingsFromDictionary(["calendar_id" : CalendarAttributes.id.rawValue, "name" : CalendarAttributes.name.rawValue, "description" : CalendarAttributes.detailDescription.rawValue])
            
            //mapping for category
            let categoryMapping = RKEntityMapping.init(forEntityForName: Category.entityName(), inManagedObjectStore: RKManagedObjectStore.defaultStore())
            categoryMapping.identificationAttributes = [CategoryAttributes.name.rawValue]
            categoryMapping.addPropertyMapping(RKAttributeMapping.init(fromKeyPath: nil, toKeyPath: CategoryAttributes.name.rawValue))

            //create relationship between calendar and categorys
            let propertyMapping = RKRelationshipMapping.init(fromKeyPath: "categories", toKeyPath: CalendarRelationships.categories.rawValue, withMapping: categoryMapping)
            calendarMapping.addPropertyMapping(propertyMapping)
            
            //setting successful codes
            let statusCodesSuccess = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
            let responseDescriptorSuccess = RKResponseDescriptor.init(mapping: calendarMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: nil, statusCodes: statusCodesSuccess)
                
            //setting failure codes
            let errorMapping = RKObjectMapping.init(forClass: ErrorHandler.self)
            errorMapping.addPropertyMapping(RKAttributeMapping.init(fromKeyPath: nil, toKeyPath: "reason"))
            let statusCodesFailure = RKStatusCodeIndexSetForClass(RKStatusCodeClass.ClientError)
            let responseDescriptorFailure = RKResponseDescriptor.init(mapping: errorMapping, method: RKRequestMethod.Any, pathPattern: nil, keyPath: nil, statusCodes: statusCodesFailure)
                
            //Creating new operation
            let operation = RKManagedObjectRequestOperation.init(request: NSURLRequest.init(URL: NSURL.init(string: "https://web-app.usc.edu/web/eo4/api/calendars")!), responseDescriptors: [responseDescriptorSuccess, responseDescriptorFailure])
            operation.managedObjectContext = NSManagedObjectContext.MR_defaultContext()
            operation.managedObjectCache = managedObjectStore.managedObjectCache
            operation.setCompletionBlockWithSuccess(success, failure: failure)
            manager.enqueueObjectRequestOperation(operation)
            
            return operation
    }
}