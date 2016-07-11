//
//  PropertyAnimator.swift
//  UIKitAnimationsExample
//
//  Created by Ildar Zalyalov on 11.07.16.
//  Copyright © 2016 com.flatstack. All rights reserved.
//

import Foundation
import UIKit

class PropertyAnimator: UIViewController {
    var circleAnimator: UIViewPropertyAnimator!
    var circleCenter: CGPoint!
    let animationDuration = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green()
        
        // add pan gesture recognizer to circle
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
        
        self.view.addSubview(circle)
        
        //add animation to UIViewPropertyAnimator
        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut, animations: {
            [weak circle] in
            // 3x scale
            circle?.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            
            })
    }
    
    // if you touch and hold circle it will "breathe"
    // stop holding for watch that circle return to normal state
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
            
        case .began, .ended:
            circleCenter = target.center
            
            if (circleAnimator.isRunning) {
                circleAnimator.pauseAnimation()
                circleAnimator.isReversed = gesture.state == .ended
            }
            circleAnimator.startAnimation()
            
            // Three important properties on an animator:
            print("Animator isRunning, isReversed, state: \(circleAnimator.isRunning), \(circleAnimator.isReversed), \(circleAnimator.state)")
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        default: break
        }
    }
}
