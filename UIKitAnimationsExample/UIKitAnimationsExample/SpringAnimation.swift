//
//  SpringAnimation.swift
//  UIKitAnimationsExample
//
//  Created by Ildar Zalyalov on 11.07.16.
//  Copyright © 2016 com.flatstack. All rights reserved.
//

import Foundation
import UIKit

class SpringAnimation: UIViewController {
    var circleCenter: CGPoint!
    // We will attach various animations to this in response to drag events
    var circleAnimator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a draggable view
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green()
        
        // add pan gesture recognizer to circle
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
        
        
        self.view.addSubview(circle)
    }
    
    
    // Drag circle to any position and then let it go! 
    
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began:
            if circleAnimator != nil && circleAnimator!.isRunning {
                circleAnimator!.stopAnimation(false)
            }
            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        case .ended:
            let v = gesture.velocity(in: target)
            
            let velocity = CGVector(dx: v.x / 500, dy: v.y / 500)
            
            //Change mass/stiffness/damping to watch different animations
            let springParameters = UISpringTimingParameters(mass: 100, stiffness: 1000, damping: 100, initialVelocity: velocity)
            circleAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
            
            circleAnimator!.addAnimations({
                target.center = self.view.center
            })
            circleAnimator!.startAnimation()
        default: break
        }
    }
}

