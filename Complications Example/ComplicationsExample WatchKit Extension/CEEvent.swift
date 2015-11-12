//
//  CEEvent.swift
//  ComplicationsExample
//
//  Created by Kruperfone on 02.10.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import Foundation
import ClockKit

class CEEvent {
    var startDate   : NSDate {
        didSet (value) {
            guard let end = self.endDate else {return}
            
            switch self.startDate.compare(end) {
            case .OrderedDescending, .OrderedSame:
                self.endDate = self.startDate
                
            default: break
            }
        }
    }
    var endDate     : NSDate?
    
    var title       : String
    var desc        : String?
    
    init (title: String, date: NSDate) {
        self.title      = title
        self.startDate  = date
    }
    
    init (title: String, startDate: NSDate, endDate: NSDate) {
        self.title      = title
        self.startDate  = startDate
        self.endDate    = endDate
    }
    
    class func getEventsForDay (day: NSDate) -> [CEEvent] {
        
        let mDate = day.midnightDate
        
        /// lastDate - ending date for last added event
        var lastDate = mDate
        var events: [CEEvent] = []
        
        while lastDate.timeIntervalSince1970 < mDate.dateByAddingTimeInterval(TimePeriod.Day.rawValue).timeIntervalSince1970 {
            
            // Randomly add or not description and endDate
            let isInterval      = arc4random()%2 == 0
            let hasDescription  = arc4random()%2 == 0
            
            // Must be greather than 2 hrs after previous event
            let startDate   = lastDate.dateByAddingTimeInterval(NSTimeInterval(arc4random_uniform(2*60*60)))
            lastDate        = startDate
            
            var event: CEEvent!
            
            if isInterval {
                // Interval must be less tha 2 hrs
                let endDate     = startDate.dateByAddingTimeInterval(NSTimeInterval(arc4random_uniform(2*60*60 - 1)))
                lastDate        = endDate
                
                event = CEEvent(title: "Title \(events.count+1)", startDate: startDate, endDate: endDate)
            } else {
                event = CEEvent(title: "Title \(events.count+1)", date: startDate)
            }
            
            if hasDescription {
                event.desc = "Description \(events.count+1)"
            }
            
            events.append(event)
        }
        
        return events
    }
}

//MARK: - Public methods
extension CEEvent {
    func getComplicationTemplate (family: CLKComplicationFamily) -> CLKComplicationTemplate {
        
        /// Default title provider
        let titleProvider: CLKTextProvider = CLKSimpleTextProvider(text: self.title)
        
        /// Provider for start time
        let timeProvider = CLKTimeTextProvider(date: self.startDate)
        
        /// Provider for displaying time offset
        let timeRelativeProvider: CLKTextProvider = CLKRelativeDateTextProvider(date: self.startDate, style: CLKRelativeDateStyle.Natural, units: [.Hour, .Minute])
        
        /// Description provider if description exist
        var descriptionProvider: CLKTextProvider?
        if let desc = self.desc {
            descriptionProvider = CLKSimpleTextProvider(text: desc)
        }
        
        /// Provider of time interval if endDate is exist
        var timeIntervalProvider: CLKTimeIntervalTextProvider?
        if let end = self.endDate {
            timeIntervalProvider = CLKTimeIntervalTextProvider(startDate: self.startDate, endDate: end)
        }
        
        switch family {
        case .ModularSmall:
            
            let template = CLKComplicationTemplateModularSmallStackText()
            
            template.line1TextProvider = timeProvider
            template.line2TextProvider = titleProvider
            template.highlightLine2 = true
            
            return template
            
        case .ModularLarge:
            
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            // Header
            if let interval = timeIntervalProvider {
                template.headerTextProvider = interval
            } else {
                template.headerTextProvider = timeProvider
            }
            
            // Title
            template.body1TextProvider = titleProvider
            
            // Description
            if let desc = descriptionProvider {
                template.body2TextProvider = desc
            } else {
                template.body2TextProvider = timeRelativeProvider
            }
            
            return template
            
        case .UtilitarianSmall:
            
            /// In that template I show minutes like progress in ring
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            
            let comps = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: self.startDate)
            
            template.textProvider   = CLKSimpleTextProvider(text: "\(comps.hour)")
            template.fillFraction   = Float(comps.minute)/60
            template.ringStyle      = .Closed
            
            return template
            
        case .UtilitarianLarge:
            
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            
            // Text provider
            if let interval = timeIntervalProvider {
                template.textProvider = interval
            } else {
                template.textProvider = timeProvider
            }
            
            return template
            
        case .CircularSmall:
            
            let template = CLKComplicationTemplateCircularSmallStackText()
            
            template.line1TextProvider = timeProvider
            template.line2TextProvider = titleProvider
            
            return template
        }
    }
}

// MARK: - Private methods
extension CEEvent {
    
}

// MARK: - Actions
extension CEEvent {
    
}

// MARK: - NSDate Helpers

enum TimePeriod: NSTimeInterval {
    case Second     = 1
    case Minute     = 60
    case Hour       = 3600
    case Day        = 86400
    case Week       = 604800
}

extension NSTimeInterval {
    var timezone: NSTimeInterval {
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate(timeIntervalSince1970: self)
        
        let timezoneOffset = NSTimeInterval(calendar.timeZone.secondsFromGMT)
        let daylightOffset = calendar.timeZone.isDaylightSavingTimeForDate(date) ? calendar.timeZone.daylightSavingTimeOffset : 0
        
        return timezoneOffset + daylightOffset
    }
}

extension NSDate {
    
    var timezone: NSTimeInterval {
        return self.timeIntervalSince1970.timezone
    }
    
    var midnightDate: NSDate {
        
        let timestamp = self.timeIntervalSince1970 + self.timezone
        let midnightTimestamp = timestamp - timestamp%(TimePeriod.Day.rawValue)
        
        let result = NSDate(timeIntervalSince1970: midnightTimestamp - midnightTimestamp.timezone)
        return result
    }
}
