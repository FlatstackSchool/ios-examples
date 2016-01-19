//
//  ComplicationController.swift
//  ComplicationsExample WatchKit Extension
//
//  Created by Kruperfone on 02.10.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var events = CEEvent.getEventsForDay(NSDate())
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Backward, .Forward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        // Midnight is start date
        handler(self.events.first?.startDate.midnightDate)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        // End date is last event startDate or endDate if exist
        if let endDate = self.events.last?.endDate {
            handler(endDate)
        } else {
            handler(events.last?.startDate)
        }
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        
        for event in self.events {
            
            if  let endDate = event.endDate where
                    NSDate().compare(event.startDate) == .OrderedDescending &&
                    NSDate().compare(endDate) == .OrderedAscending {
                        
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: event.getComplicationTemplate(complication.family))
                handler(entry)
                break
                        
            } else {
                
                if NSDate().compare(event.startDate) == NSComparisonResult.OrderedAscending {
                    
                    let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: event.getComplicationTemplate(complication.family))
                    handler(entry)
                    break
                }
            }
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        
        var entries: [CLKComplicationTimelineEntry] = []
        
        /// Filtered array for past dates
        let events = self.events.filter { (event: CEEvent) -> Bool in
            return date.compare(event.startDate) == .OrderedDescending
        }
        
        /* We start from midnight default lastDate and set date of previous event for current complication because we must see that complication right after previous was ended*/
        
        var lastDate = date.midnightDate
        
        for event in events {
            let entry = CLKComplicationTimelineEntry(date: lastDate, complicationTemplate: event.getComplicationTemplate(complication.family))
            
            if let endDate = event.endDate {
                lastDate = endDate
            } else {
                lastDate = event.startDate
            }
            
            entries.append(entry)
            
            if entries.count >= limit {
                break
            }
        }
        
        handler(entries)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        
        var entries: [CLKComplicationTimelineEntry] = []
        
        /// Filtered array for future dates
        let events = self.events.filter { (event: CEEvent) -> Bool in
            if let endDate = event.endDate {
                return date.compare(endDate) == .OrderedAscending
            } else {
                return date.compare(event.startDate) == .OrderedAscending
            }
        }
        
        var lastDate = date.dateByAddingTimeInterval(1)
        
        for event in events {
            
            let entry = CLKComplicationTimelineEntry(date: lastDate, complicationTemplate: event.getComplicationTemplate(complication.family))
            
            if let endDate = event.endDate {
                lastDate = endDate
            } else {
                lastDate = event.startDate
            }
            
            entries.append(entry)
            
            if entries.count >= limit {
                break
            }
        }
        
        handler(entries)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        let start = NSDate()
        let end = start.dateByAddingTimeInterval(2*TimePeriod.Hour.rawValue)
        
        let event = CEEvent(title: "Title", startDate: start, endDate: end)
        event.desc = "Description"
        
        let template = event.getComplicationTemplate(complication.family)
        
        handler(template)
    }
    
}
