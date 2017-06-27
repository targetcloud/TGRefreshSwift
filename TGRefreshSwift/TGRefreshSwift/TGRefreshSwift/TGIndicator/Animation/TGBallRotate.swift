//
//  TGBallRotate.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGBallRotate: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize: CGFloat = size.width / 5
        let duration: CFTimeInterval = 1
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.7, -0.13, 0.22, 0.86)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [1, 0.6, 1]
        scaleAnimation.duration = duration
        
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.timingFunctions = [timingFunction, timingFunction]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        rotateAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, rotateAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        let leftCircle = TGIndicatorShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
        let rightCircle = TGIndicatorShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
        let centerCircle = TGIndicatorShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
        
        leftCircle.opacity = 0.8
        leftCircle.frame = CGRect(x: 0, y: (size.height - circleSize) / 2, width: circleSize, height: circleSize)
        rightCircle.opacity = 0.8
        rightCircle.frame = CGRect(x: size.width - circleSize, y: (size.height - circleSize) / 2, width: circleSize, height: circleSize)
        centerCircle.frame = CGRect(x: (size.width - circleSize) / 2, y: (size.height - circleSize) / 2, width: circleSize, height: circleSize)
        
        let circle = CALayer()
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2, y: (layer.bounds.size.height - size.height) / 2, width: size.width, height: size.height)
        
        circle.frame = frame
        circle.addSublayer(leftCircle)
        circle.addSublayer(rightCircle)
        circle.addSublayer(centerCircle)
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
