//
//  TGBallScale.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGBallScale: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        
        // Opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        
        opacityAnimation.duration = duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circle
        let circle = TGIndicatorShape.circle.layerWith(size: size, color: color)
        
        circle.frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                              y: (layer.bounds.size.height - size.height) / 2,
                              width: size.width,
                              height: size.height)
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
