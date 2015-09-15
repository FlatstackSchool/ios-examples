//
//  FirstSnapViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 17.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import SnapKit

class FirstSnapViewController: UIViewController {
    
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
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.height.equalTo(20)
        }
        
        self.greenView.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(20)
            make.top.equalTo(self.redView.snp_bottom).offset(20)
            make.left.equalTo(self.redView.snp_right)
        }
        
        self.blueView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(10)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.greenView.snp_bottom)
        }
        
        self.yellowView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(self.blueView.snp_width)
            make.top.equalTo(self.blueView.snp_bottom).offset(20)
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
