//
//  SecondViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 13.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import PureLayout

class SecondViewController: UIViewController {
    
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
        
        arrayOfViews.autoSetViewsDimension(ALDimension.Height, toSize:25)
        arrayOfViews.autoMatchViewsDimension(ALDimension.Width)
        
        self.redView.autoPinToTopLayoutGuideOfViewController(self, withInset: 30)
        
        self.redView.autoPinEdgeToSuperviewEdge(ALEdge.Left)
        self.yellowView.autoPinEdgeToSuperviewEdge(ALEdge.Right)
        
        
        var prevView: UIView! = nil
        for view in arrayOfViews {
            if let lView = prevView {
                lView.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Left, ofView: view as! UIView)
                lView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: view as! UIView)
            }
            prevView = view as! UIView
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
