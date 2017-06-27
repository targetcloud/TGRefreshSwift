//
//  TGBallRotateChase.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGBallRotateChase: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize = size.width / 5
        
        // Draw circles
        for i in 0 ..< 5 {
            let factor = Float(i) * 1 / 5
            let circle = TGIndicatorShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
            let animation = rotateAnimation(factor, x: layer.bounds.size.width / 2, y: layer.bounds.size.height / 2, size: CGSize(width: size.width - circleSize, height: size.height - circleSize))
            
            circle.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    func rotateAnimation(_ rate: Float, x: CGFloat, y: CGFloat, size: CGSize) -> CAAnimationGroup {
        let duration: CFTimeInterval = 1.5
        let fromScale = 1 - rate
        let toScale = 0.2 + rate
        let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.fromValue = fromScale
        scaleAnimation.toValue = toScale
        
        // Position animation
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.repeatCount = HUGE
        positionAnimation.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: size.width / 2, startAngle: CGFloat(3 * Double.pi * 0.5), endAngle: CGFloat(3 * Double.pi * 0.5 + 2 * Double.pi), clockwise: true).cgPath
        
        // Aniamtion
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, positionAnimation]
        animation.timingFunction = timeFunc
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        return animation
    }

}
