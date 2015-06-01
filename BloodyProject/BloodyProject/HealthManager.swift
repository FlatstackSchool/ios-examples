//
//  HealthManager.swift
//  BloodyProject
//
//  Created by Kruperfone on 25.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import HealthKit

struct User {
    let age:Int?
    let height:Double?
    let weight:Double?
    let blood:String?
    let sex:String?
}

struct Note {
    let value:Double
    let type:NoteType
    let date:NSDate
}

enum NoteType:String {
    case Glucose =  "glucose"
    case Oxygen =   "oxygen"
    
    var title:String {
        switch self {
        case .Glucose:  return "Глюкоза"
        case .Oxygen:   return "Кислород"
        }
    }
    
    var unit:String {
        switch self {
        case .Glucose:  return "ммоль/л"
        case .Oxygen:   return "%"
        }
    }
}

class HealthManager: NSObject {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    let pref = NSUserDefaults.standardUserDefaults()
    var notes:[Note] = []
    
    let kWritedData = "WritedData"
    
    class var sharedInstance: HealthManager {
        struct Static {
            static var instance: HealthManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = HealthManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        
        if let data = pref.objectForKey(kWritedData) as? [Dictionary<String, AnyObject>] {
            
            for current in data {
                if let typeString = current["type"] as? String, type = NoteType(rawValue: typeString), value = current["value"] as? Double, date = current["date"] as? NSDate {
                    notes.append(Note(value: value, type: type, date: date))
                }
            }
        }
        
        super.init()
    }
    
    //MARK: - Request acces
    func requestAccess (completion: ((success:Bool, error:NSError!) -> Void)?) {
        
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.flatstack.development.health", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion?(success:false, error:error)
            }
            return;
        }
        
        let readArray:[HKObjectType] = [
            HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
            HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
            HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        ]
        
        let healthKitTypesToRead:Set<HKObjectType> = Set(readArray)
        
        let writeArray:[HKObjectType] = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierOxygenSaturation)
        ]
        
        let healthKitTypesToWrite:Set<HKObjectType> = Set(writeArray)
        
        self.healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success:Bool, error:NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                completion?(success: success, error: error)
                
            })
            
        }
        
    }
    
    //MARK: - Write data to Health App
    func writeSample (#value:Double, type:NoteType) {
        
        let date = NSDate()
        
        var note = Note(value: value, type: type, date: date)
        
        var identifier = ""
        var unit:HKUnit!
        var writeValue:Double!
        
        switch type {
        case NoteType.Glucose:
            identifier = HKQuantityTypeIdentifierBloodGlucose
            unit = HKUnit.moleUnitWithMetricPrefix(HKMetricPrefix.Milli, molarMass: HKUnitMolarMassBloodGlucose).unitDividedByUnit(HKUnit.literUnit())
            writeValue = value
            break
            
        case NoteType.Oxygen:
            identifier = HKQuantityTypeIdentifierOxygenSaturation
            unit = HKUnit.percentUnit()
            writeValue = value/100
            break
        }
        
        var qType = HKQuantityType.quantityTypeForIdentifier(identifier)
        var quantity = HKQuantity(unit: unit, doubleValue: writeValue)
        var sample = HKQuantitySample(type: qType, quantity: quantity, startDate: date, endDate: date)
        
        healthKitStore.saveObject(sample, withCompletion: { (success:Bool, error:NSError!) -> Void in
            if success {
                self.notes.append(note)
                self.saveData()
                
                NSNotificationCenter.defaultCenter().postNotificationName("SaveNote", object: self)
                
            } else if error != nil {
                println("Failed while save note. Error: \(error)")
            }
        })
    }
    
    private func saveData () {
        
        var writedArray:[Dictionary<String, AnyObject>] = []
        
        for note in self.notes {
            writedArray.append(["value":note.value,"type":note.type.rawValue,"date":note.date])
        }
        
        self.pref.setObject(writedArray, forKey: kWritedData)
        self.pref.synchronize()
    }
    
    //MARK: - Getting User data
    
    func getUserData () -> User {
        
        var error:NSError?
        var age:Int?
        var blood:String?
        var sex:String?
        
        var height:Double?
        var weight:Double?
        
        //AGE
        if let birthDay = healthKitStore.dateOfBirthWithError(&error)
        {
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: birthDay, toDate: today, options: NSCalendarOptions(0) )
            age = differenceComponents.year
        } else {
            if error != nil {
                println("Error reading Birthday: \(error)")
            }
        }
        
        //BLOOD
        var bloodType:HKBloodTypeObject? = healthKitStore.bloodTypeWithError(&error)
        
        if let type = bloodType {
            
            switch type.bloodType {
            case .APositive:   blood = "II+"
            case .ANegative:    blood = "II-"
            case .BPositive:    blood = "III+"
            case .BNegative:    blood = "III-"
            case .ABPositive:   blood = "IV+"
            case .ABNegative:   blood = "IV-"
            case .OPositive:    blood = "I+"
            case .ONegative:    blood = "I-"
            default: break
            }
            
        } else if error != nil {
            println("Error reading Blood Type: \(error)")
        }
        
        //SEX
        var biologicalSex:HKBiologicalSexObject? = healthKitStore.biologicalSexWithError(&error)!
        
        if let bioSex = biologicalSex {
            
            switch bioSex.biologicalSex {
            case HKBiologicalSex.Male:      sex = "М"
            case HKBiologicalSex.Female:    sex = "Ж"
            default: break
            }
            
        } else if error != nil {
            println("Error reading Biological Sex: \(error)")
        }
        
        var group = dispatch_group_create()
        
        //HEIGHT
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            
            let heightQty = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
            
            var semaphore = dispatch_semaphore_create(0)
            
            self.readMostRecentSample(heightQty, completion: { (sample:HKQuantitySample?, error:NSError!) -> Void in
                if error == nil {
                    if let _sample = sample {
                        height = _sample.quantity.doubleValueForUnit(HKUnit.meterUnit())*100
                    }
                    
                } else {
                    println("Error reading Height: \(error)")
                }
                
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        
        //WEIGHT
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            
            let weightQty = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
            
            var semaphore = dispatch_semaphore_create(0)
            
            self.readMostRecentSample(weightQty, completion: { (sample:HKQuantitySample?, error:NSError!) -> Void in
                if error == nil {
                    if let _sample = sample {
                        weight = _sample.quantity.doubleValueForUnit(HKUnit.gramUnit())/1000
                    }
                    
                } else {
                    println("Error reading Weight: \(error)")
                }
                
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        return User(age: age, height: height, weight: weight, blood: blood, sex: sex)
    }
    
    private func readMostRecentSample(sampleType:HKSampleType , completion: ((HKQuantitySample?, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast() as! NSDate
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion(nil,error)
                    return;
                }
                
                // Get the first sample
                let mostRecentSample = results.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
}
