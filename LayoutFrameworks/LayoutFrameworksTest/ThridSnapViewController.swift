//
//  ThridSnapViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 18.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit
import SnapKit

class ThridSnapViewController: UIViewController {
    
    let redView = UILabel(frame: CGRectMake(10, 10, 20, 40))
    let greenView = UILabel(frame: CGRectMake(10, 10, 20, 40))
    let blueView = UILabel(frame: CGRectMake(10, 10, 20, 40))
    let yellowView = UILabel(frame: CGRectMake(10, 10, 20, 40))
    
    override func loadView() {
        super.loadView()
        
        self.redView.backgroundColor = UIColor.redColor()
        self.redView.numberOfLines = 0
        self.view.addSubview(redView)
        
        self.greenView.backgroundColor = UIColor.greenColor()
        self.greenView.numberOfLines = 0
        self.view.addSubview(greenView)
        
        self.blueView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(blueView)
        
        self.yellowView.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(yellowView)
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redView.text = "123456 dfgj osdf glojsfgl sdfkj g;sdkfh;ok fsjg;ohkj s;fokgjh ;slkfjg;h ksfg;jh sklfjgh;ksjf g;;jksdnfg 999"
        self.greenView.text = "aaaaa fgkh fgh dfgh dfgh dfgh ggg"
        
        self.redView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(100)
            make.leading.equalTo(self.view.snp_left).offset(20)
            make.height.equalTo(200)
        }
        
        self.greenView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(100)
            make.trailing.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(200)
            
            make.leading.equalTo(self.redView.snp_trailing).offset(20)
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
