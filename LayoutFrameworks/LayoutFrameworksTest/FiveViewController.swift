//
//  FiveViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 14.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import PureLayout

class FiveViewController: UIViewController {
    
    let redView = UIView(frame: CGRectMake(10, 10, 20, 40))
    let greenView = UIView(frame: CGRectMake(10, 10, 20, 40))
    let blueView = UIView(frame: CGRectMake(10, 10, 20, 40))
    let yellowView = UIView(frame: CGRectMake(10, 10, 20, 40))
    
    override func loadView() {
        super.loadView()
        
        self.redView.backgroundColor = UIColor.redColor()
        self.view.addSubview(redView)
        
        self.greenView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(greenView)
        
        self.blueView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(blueView)
        
        self.yellowView.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(yellowView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redView.autoSetDimensionsToSize(CGSizeMake(100, 40))
        self.redView.autoPinToTopLayoutGuideOfViewController(self, withInset: 200)
        self.redView.autoAlignAxis(ALAxis.Vertical, toSameAxisOfView: self.view, withOffset: -200)
        
        self.greenView.autoSetDimension(ALDimension.Width, toSize: 1)
        self.greenView.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        self.greenView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        self.greenView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
        
        
        self.blueView.autoPinToTopLayoutGuideOfViewController(self, withInset: 300)
        self.blueView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 20)
        self.blueView.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: self.greenView, withOffset: 20, relation: NSLayoutRelation.GreaterThanOrEqual)
        self.blueView.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20, relation: NSLayoutRelation.GreaterThanOrEqual)
        
        UIView.autoSetPriority(750, forConstraints: { () -> Void in
            self.blueView.autoSetDimensionsToSize(CGSizeMake(100000, 100000))
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
