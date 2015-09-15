//
//  SecondSnapViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 17.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import SnapKit

class SecondSnapViewController: UIViewController {
    
    let redView = UIButton(frame: CGRectMake(10, 10, 20, 40))
    let greenView = UIButton(frame: CGRectMake(10, 10, 20, 40))
    let blueView = UIView(frame: CGRectMake(10, 10, 20, 40))
    let yellowView = UIView(frame: CGRectMake(10, 10, 20, 40))
    
    var isFirstPosition = true
    
    var constr: Constraint?
    var curentHeight = 20
    
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
            make.center.equalTo(self.view.snp_center)
            self.constr = make.width.height.equalTo(curentHeight).constraint
        }
        
        self.remakeConstraints();
    }
    
    func updateConstraints() {
        if let lConstraint = self.constr {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.curentHeight += 20
                lConstraint.updateOffset(self.curentHeight)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func remakeConstraints() {
        self.isFirstPosition = !self.isFirstPosition
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if self.isFirstPosition {
                self.greenView.snp_remakeConstraints { (make) -> Void in
                    make.width.height.equalTo(20)
                    make.left.equalTo(self.view.snp_left).offset(150)
                    make.top.equalTo(self.view.snp_top).offset(150)
                }
            } else {
                self.greenView.snp_remakeConstraints { (make) -> Void in
                    make.width.height.equalTo(20)
                    make.right.equalTo(self.view.snp_right).offset(-150)
                    make.bottom.equalTo(self.view.snp_bottom).offset(-150)
                }
            }
            self.view.layoutIfNeeded()
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
