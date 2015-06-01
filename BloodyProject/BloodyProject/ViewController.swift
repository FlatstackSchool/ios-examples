//
//  ViewController.swift
//  BloodyProject
//
//  Created by Kruperfone on 25.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UIActionSheetDelegate, AddNoteDelegate, UITableViewDataSource {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var requestAccessButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    var addNoteViewController:AddNoteViewController?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "SaveNote", object: nil)
    }
    
    func updateUserData () {
        
        let user = HealthManager.sharedInstance.getUserData()
        
        if let age = user.age {
            self.ageLabel.text = "\(age)"
        } else {
            self.ageLabel.text = "Not avialible"
        }
        
        if let height = user.height {
            self.heightLabel.text = "\(height)"
        } else {
            self.heightLabel.text = "Not avialible"
        }
        
        if let weight = user.weight {
            self.weightLabel.text = "\(weight)"
        } else {
            self.weightLabel.text = "Not avialible"
        }
        
        if let blood = user.blood {
            self.bloodLabel.text = "\(blood)"
        } else {
            self.bloodLabel.text = "Not avialible"
        }
        
        if let sex = user.sex {
            self.sexLabel.text = sex
        } else {
            self.sexLabel.text = "Not avialible"
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func requestAccessTapped(sender: AnyObject) {
        
        let manager = HealthManager.sharedInstance
        
        weak var wself = self
        
        manager.requestAccess { (success, error) -> Void in
            
            if let sself = wself {
                
                sself.requestAccessButton.enabled = !success
                
                if success {
                    sself.updateUserData()
                }
            }
        }
        
    }
    
    @IBAction func addNodeTapped(sender: AnyObject) {
        var actionSheet = UIActionSheet(title: "Какую запись вы хотите добавить?", delegate: self, cancelButtonTitle: "Отмена", destructiveButtonTitle: nil, otherButtonTitles: "Глюкоза", "Кислород")
        
        actionSheet.tag = 1
        actionSheet.showInView(self.view)
    }
    
    //MARK: UIActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case 1:
            switch buttonIndex {
            case 1:
                self.showAddNoteController(NoteType.Glucose)
                
            case 2:
                self.showAddNoteController(NoteType.Oxygen)
                
            default: break
            }
            
        default: break
        }
    }
    
    //MARK: - AddNoteViewController
    
    func showAddNoteController (type:NoteType) {
        if let noteViewController = self.addNoteViewController {
            noteViewController.prepareController(type)
            
            self.containerView.alpha = 0
            
            self.containerView.hidden = false
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                
                self.containerView.alpha = 1
            })
        }
    }
    
    func hideAddNoteController () {
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.containerView.alpha = 0
            }) { (completed:Bool) -> Void in
            self.containerView.hidden = true
        }
    }
    
    func saveNote (value:Double, type:NoteType) {
        
        HealthManager.sharedInstance.writeSample(value: value, type: type)
        self.hideAddNoteController()
    }
    
    func cancelNote () {
        self.hideAddNoteController()
    }
    
    //MARK: - UITableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HealthManager.sharedInstance.notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("BloodCell") as! BloodCell
        cell.prepareCell(HealthManager.sharedInstance.notes[indexPath.row])
        return cell
    }
    
    //MARK: -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "AddNoteSegue":
                self.addNoteViewController = segue.destinationViewController as? AddNoteViewController
                self.addNoteViewController?.delegate = self
                
            default: break
            }
        }
    }
    
    func reloadData () {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    
}

