//
//  TableViewCell.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 17.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightLabelView: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var operation: SDWebImageOperation? = nil

    override func prepareForReuse() {
        if testCustomCache == false {
            self.leftImageView.sd_cancelCurrentImageLoad()
            self.leftImageView.sd_cancelCurrentAnimationImagesLoad()
        } else {
            self.operation?.cancel()
        }

        self.leftImageView.image = nil
        
        self.rightLabelView.text = nil
        self.indicatorView.stopAnimating()
    }
}
