//
//  BloodCell.swift
//  BloodyProject
//
//  Created by Kruperfone on 25.05.15.
//  Copyright (c) 2015 KruperSoft. All rights reserved.
//

import UIKit
import HealthKit

class BloodCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    var note:Note!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell (note:Note) {
        
        self.note = note
        
        self.valueLabel.text = "\(note.value)"
        self.titleLabel.text = note.type.title
        self.unitLabel.text = note.type.unit
        
    }
}
