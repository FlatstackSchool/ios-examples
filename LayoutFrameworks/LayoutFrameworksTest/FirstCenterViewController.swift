//
//  FirstCenterViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 11.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import PureLayout

class FirstCenterViewController: UIViewController {
    
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

        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.redView.autoCenterInSuperview() // по центру
        self.redView.autoSetDimension(ALDimension.Width, toSize: 20)
        self.redView.autoSetDimension(ALDimension.Height, toSize: 20)
        
        self.greenView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: redView, withOffset: 20)
        self.greenView.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: redView)
        self.greenView.autoSetDimension(ALDimension.Width, toSize: 20)
        self.greenView.autoSetDimension(ALDimension.Height, toSize: 20)
        
        self.blueView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.greenView)
        self.blueView.autoSetDimension(ALDimension.Height, toSize: 10)
        self.blueView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 30)
        self.blueView.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 30)
        
        self.yellowView.autoSetDimension(ALDimension.Height, toSize: 20)
        self.yellowView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.blueView, withOffset: 30)
        self.yellowView.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        self.yellowView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.blueView)
        
        
        self.view.addSubview(redView);
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
