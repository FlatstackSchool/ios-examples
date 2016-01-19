//
//  FourthSnapViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 18.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import SnapKit

class FourthSnapViewController: UIViewController {
    
    let redView = UIButton(frame: CGRectMake(10, 10, 20, 40))
    let greenView = UIButton(frame: CGRectMake(10, 10, 20, 40))
    let blueView = UIView(frame: CGRectMake(10, 10, 20, 40))
    let yellowView = UIView(frame: CGRectMake(10, 10, 20, 40))
    
    override func loadView() {
        super.loadView()
        
        self.redView.backgroundColor = UIColor.redColor()
        self.view.addSubview(redView)
        self.redView.addTarget(self, action: "updateConstraints", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.greenView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(greenView)
        self.greenView.addTarget(self, action: "remakeConstraints", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.blueView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(blueView)
        
        self.yellowView.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(yellowView)
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(100, 40))
            make.top.equalTo(self.view).offset(200)
            make.centerX.equalTo(self.view).offset(-200)
        }
        
        self.greenView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(1)
            make.top.equalTo(self.view.snp_top)
            make.bottom.equalTo(self.view.snp_bottom)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
        self.blueView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(300)
            make.bottom.equalTo(self.view).offset(-20)
            make.left.equalTo(self.greenView.snp_right).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.size.equalTo(CGSizeMake(1000000, 1000000)).priorityLow()
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
