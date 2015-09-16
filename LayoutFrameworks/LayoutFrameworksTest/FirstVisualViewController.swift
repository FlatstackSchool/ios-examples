//
//  FirstVisualViewController.swift
//  LayoutFrameworksTest
//
//  Created by Nikita Fomin on 18.08.15.
//  Copyright (c) 2015 Nikita Fomin. All rights reserved.
//

import UIKit

class FirstVisualViewController: UIViewController {
    
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
        
        self.redView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.greenView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.blueView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.yellowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //Views to add constraints to
        let views = Dictionary(dictionaryLiteral: ("red",self.redView),("blue",self.blueView),("green",self.greenView))
        //Metrics for Visual Format string
        let metrics = Dictionary(dictionaryLiteral: ("spacing", 10),("lowWidth",100),("highWidth",200),("priority",20),("redBlueSpacing",0),("greenHeight",40))
        
        //Horizontal constraints
        let horizontalConstraintsRedBlue = NSLayoutConstraint.constraintsWithVisualFormat("H:|-spacing-[red(>=lowWidth,<=highWidth@priority)]-redBlueSpacing-[blue(==red)]-spacing-|", options: nil, metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraintsRedBlue)
        let horizontalConstraintsGreen = NSLayoutConstraint.constraintsWithVisualFormat("H:|[green]|", options: nil, metrics: nil, views: views)
        self.view.addConstraints(horizontalConstraintsGreen)
        
        //Vertical constraints
        let verticalConstraintsRed = NSLayoutConstraint.constraintsWithVisualFormat("V:|[red]-spacing-[green(greenHeight)]|", options: nil, metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraintsRed)
        let verticalConstraintsBlue = NSLayoutConstraint.constraintsWithVisualFormat("V:|[blue]|", options: nil, metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraintsBlue)
        
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
