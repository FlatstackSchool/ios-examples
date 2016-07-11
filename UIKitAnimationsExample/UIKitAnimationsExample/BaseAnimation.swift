//
//  BaseAnimation.swift
//  UIKitAnimationsExample
//
//  Created by Ildar Zalyalov on 11.07.16.
//  Copyright © 2016 com.flatstack. All rights reserved.
//

import Foundation
import UIKit

class BaseAnimation: UIViewController {
    
    var circleCenter: CGPoint!
    var propertyAnimator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a draggable view
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green()
        
        // add pan gesture recognizer to circle
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))

        
        /********* #1 Show that we can add as many Animation as we want  *********/

                self.propertyAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .easeInOut, animations: {
        
                    circle.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                    circle.backgroundColor = UIColor.red()
                    circle.transform = CGAffineTransform(a: 10, b: 15, c: 25, d: 30, tx: self.view.center.x, ty: self.view.center.y)
        
                })
        
          /****   ****/
        
        
        /********* #2 Show how to use CubicTimingParameters to define a custom cubic Bézier curve ******/
        
         // Commit #1 and #3 section before uncommit this section for properly demonstration
        
//         let curveProvider = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.2, y: -0.48), controlPoint2: CGPoint(x: 0.79, y: 1.41))
//        
//        self.propertyAnimator = UIViewPropertyAnimator (duration: 3.0, controlPoint1: curveProvider.controlPoint1, controlPoint2: curveProvider.controlPoint2, animations: { 
//            circle.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
//            circle.backgroundColor = UIColor.red()
//            circle.transform = CGAffineTransform(a: 10, b: 15, c: 25, d: 30, tx: self.view.center.x, ty: self.view.center.y)
//        })
        
        /****   ****/
        
      /********* #3 Show that we can add Animation "on the fly" when we want with delayFactor  *********/
        
     // Commit #1 and #2 section before uncommit this section for properly demonstration
        
//        self.propertyAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
//            circle.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
//        })
//        
        
//        self.propertyAnimator.addAnimations({
//            circle.backgroundColor = UIColor.blue()
//            }, delayFactor: 1.0)
        
      /****   ****/
        
        self.view.addSubview(circle)
        
    }
    
    //MARK: - Custom methods
    
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began, .ended:
            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        default: break
        }
    }
    
    //MARK: - Buttons action
    
    @IBAction func playPressed(_ sender: AnyObject) {
        //Start animation
        self.propertyAnimator.startAnimation()
    }
    
    @IBAction func pausePressed(_ sender: AnyObject) {
        //Pause animation on any position
        self.propertyAnimator.pauseAnimation()
    }
    @IBAction func refreshPressed(_ sender: AnyObject) {
        //Tell to animation go back to begin position
        self.propertyAnimator.isReversed = true
    }
    
}
