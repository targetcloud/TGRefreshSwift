//
//  TGSquarePulse.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGSquarePulse: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let squareSpacing: CGFloat = 2
        let squareSize = (size.width - 2 * squareSpacing) / 3
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - squareSize) / 2
        let duration: CFTimeInterval = 0.75
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.3, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [1, 0.3, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.keyTimes = [0, 0.3, 1]
        opacityAnimation.timingFunctions = [timingFunction, timingFunction]
        opacityAnimation.values = [1, 0.7, 1]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [scaleAnimation, opacityAnimation]
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        
        // Draw squareSizes
        for i in 0 ..< 3 {
                let square = TGIndicatorShape.rectangle.layerWith(size: CGSize(width: squareSize, height: squareSize), color: color)
                let frame = CGRect(x: x + squareSize * CGFloat(i) + squareSpacing * CGFloat(i),
                                   y: y,
                                   width: squareSize,
                                   height: squareSize)
                animation.beginTime = beginTime + beginTimes[i]
                square.frame = frame
                square.add(animation, forKey: "animation")
                layer.addSublayer(square)
        }
    }
}
