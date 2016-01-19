//
//  ThirdViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 14.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import PureLayout

class ThirdViewController: UIViewController {
    
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
        
        let arrayOfViews = [self.redView, self.greenView, self.blueView, self.yellowView] as NSArray
        
        arrayOfViews.autoSetViewsDimension(ALDimension.Height, toSize: 100)
        arrayOfViews.autoDistributeViewsAlongAxis(ALAxis.Horizontal, alignedTo: ALAttribute.Horizontal, withFixedSpacing: 30, insetSpacing: true, matchedSizes: true)
        self.redView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
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
