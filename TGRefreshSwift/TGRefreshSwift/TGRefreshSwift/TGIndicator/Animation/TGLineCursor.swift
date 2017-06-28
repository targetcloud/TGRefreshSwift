//
//  TGLineCursor.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGLineCursor: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / 10
        let x = (layer.bounds.size.width - size.width) / 2  + (size.width - lineSize) / 2
        let y = (layer.bounds.size.height - size.height) / 2 
        //print("\(layer.bounds.size.width) \(size.width) \(x) \(y)")
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)//0.7, -0.13, 0.22, 0.86
        
        // Animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [0.6, 0.4, 0.6]
        scaleAnimation.duration = duration
    
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.timingFunctions = [timingFunction, timingFunction]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        rotateAnimation.duration = duration
        
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, rotateAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        
        let line = TGIndicatorShape.line.layerWith(size: CGSize(width: lineSize, height: size.height), color: color)
        let frame = CGRect(x: x, y: y, width: lineSize, height: size.height)
        
        animation.beginTime = beginTime
        line.frame = frame
        line.add(animation, forKey: "animation")
        layer.addSublayer(line)
    }
}
