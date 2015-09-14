//
//  SixViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 14.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import PureLayout

class SixViewController: UIViewController {
    
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
        
        self.redView.autoSetDimensionsToSize(CGSizeMake(100, 100))
        
        let leftConstraint = self.redView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20)
        let rightConstraint = self.redView.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 20)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(10, animations: { () -> Void in
                leftConstraint.constant = 500
                rightConstraint.constant = 500
                self.view.layoutIfNeeded()
            })
        }
        
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
