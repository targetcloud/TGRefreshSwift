//
//  TGWindows.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGWindows: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let squareSpacing: CGFloat = 2
        let squareSize = (size.width - squareSpacing) / 2
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 0.6
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24,0.48, 0.36]
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [1, 0.5, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.keyTimes = [0, 0.5, 1]
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
        for i in 0 ..< 2 {
            for j in 0 ..< 2{
                let square = TGIndicatorShape.rectangle.layerWith(size: CGSize(width: squareSize, height: squareSize), color: color)
                let frame = CGRect(x: x + squareSize * CGFloat(j) + squareSpacing * CGFloat(j),
                                   y: y + squareSize * CGFloat(i) + squareSpacing * CGFloat(i),
                                   width: squareSize,
                                   height: squareSize)
                animation.beginTime = beginTime + beginTimes[2 * i + j]
                square.frame = frame
                square.add(animation, forKey: "animation")
                layer.addSublayer(square)
            }
        }
    }
}
