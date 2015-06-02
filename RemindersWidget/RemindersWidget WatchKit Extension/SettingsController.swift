//
//  SettingsController.swift
//  RemindersWidget
//
//  Created by Kruperfone on 12.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import WatchKit
import Foundation

let kSettings = "kWatchSettings"
let kSettingsShowPriority = "kWatchSettingsShowPriority"
let kSettingsFontSize = "kWatchSettingsFontSize"

class SettingsController: WKInterfaceController {

    @IBOutlet weak var prioritySwitch: WKInterfaceSwitch!
    @IBOutlet weak var fontSizeSlider: WKInterfaceSlider!
    
    var sliderValue:Float = 3
    var switchValue = true
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let pref = NSUserDefaults.standardUserDefaults()
        
        if let dict = pref.objectForKey(kSettings) as? Dictionary<String, AnyObject> {
            
            if let show = dict[kSettingsShowPriority] as? Bool {
                self.switchValue = show
                self.prioritySwitch.setOn(show)
            }
            
            if let fontSize = dict[kSettingsFontSize] as? Int {
                self.sliderValue = Float(fontSize)
                self.fontSizeSlider.setValue(Float(fontSize))
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        super.didDeactivate()
    }

    @IBAction func switchValueChanged(value: Bool) {
        self.switchValue = value
        
        let pref = NSUserDefaults.standardUserDefaults()
        
        var dict = [kSettingsFontSize : self.sliderValue, kSettingsShowPriority : self.switchValue]
        
        pref.setObject(dict, forKey: kSettings)
        pref.synchronize()
    }
    @IBAction func fontSizeChanged(value: Float) {
        sliderValue = value
        
        let pref = NSUserDefaults.standardUserDefaults()
        
        var dict = [kSettingsFontSize : self.sliderValue, kSettingsShowPriority : self.switchValue]
        
        pref.setObject(dict, forKey: kSettings)
        pref.synchronize()
    }
}
