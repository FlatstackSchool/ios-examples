//
//  Helpers.swift
//  Ad-Examples
//
//  Created by Kruperfone on 19.11.15.
//  Copyright © 2015 Flatstack. All rights reserved.
//

import UIKit

// MARK: - Autolayout Constraints
func FSVisualConstraints (
    format: String,
    options: NSLayoutFormatOptions = .DirectionLeadingToTrailing,
    metrics: [String : AnyObject]? = nil,
    views: [String : AnyObject]) -> [NSLayoutConstraint]
{
    let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
    return constraints
}

func FSEdgesConstraints (view: UIView, edges: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)) -> [NSLayoutConstraint] {
    
    let dict = ["view":view]
    let metrics = ["LEFT":edges.left, "TOP":edges.top, "RIGHT":edges.right, "BOTTOM":edges.bottom]
    
    var constraints:[NSLayoutConstraint] = []
    
    constraints += FSVisualConstraints("H:|-LEFT-[view]-RIGHT-|", options: [], metrics: metrics, views: dict)
    constraints += FSVisualConstraints("V:|-TOP-[view]-BOTTOM-|", options: [], metrics: metrics, views: dict)
    
    return constraints
}

func FSSizeConstraints (view:UIView, size:CGSize) -> [NSLayoutConstraint] {
    let dict = ["view":view]
    let metrics = ["WIDTH":size.width, "HEIGHT":size.height]
    
    var constraints:[NSLayoutConstraint] = []
    
    constraints += FSVisualConstraints("H:[view(WIDTH)]", options: [], metrics: metrics, views: dict)
    constraints += FSVisualConstraints("V:[view(HEIGHT)]", options: [], metrics: metrics, views: dict)
    
    return constraints
}

func FSCenterConstraints (view: UIView, centerOffset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
    return [
        NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: view.superview!, attribute: .CenterX, multiplier: 1, constant: centerOffset.x),
        NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: view.superview!, attribute: .CenterY, multiplier: 1, constant: centerOffset.y)
    ]
}

func FSCenterYConstraints (view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
    
    return NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: view.superview, attribute: .CenterY, multiplier: 1, constant: 0)
}

func FSCenterXConstraint (view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: view.superview, attribute: .CenterX, multiplier: 1, constant: 0)
}

func FSProportionalWidthConstraints (view: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: view.superview, attribute: .Width, multiplier: multipler, constant: constant)
}

func FSProportionalHeightConstraint (view: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: view.superview, attribute: .Height, multiplier: multipler, constant: constant)
}
