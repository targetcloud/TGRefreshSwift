//
//  TGTriangleSkewSpin.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGTriangleSkewSpin: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 3
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.09, 0.57, 0.49, 0.9)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animation.timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
        animation.values = [
            NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: 0))),
            NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: CGFloat(Double.pi)), createRotateYTransform(angle: 0))),
            NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: CGFloat(Double.pi)), createRotateYTransform(angle: CGFloat(Double.pi)))),
            NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: CGFloat(Double.pi)))),
            NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: 0))),
        ]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw triangle
        let triangle = TGIndicatorShape.triangle.layerWith(size: size, color: color)
        
        triangle.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        triangle.add(animation, forKey: "animation")
        layer.addSublayer(triangle)
    }
    
    func createRotateXTransform(angle: CGFloat) -> CATransform3D {
        var transform = CATransform3DMakeRotation(angle, 1, 0, 0)
        
        transform.m34 = CGFloat(-1) / 100
        
        return transform
    }
    
    func createRotateYTransform(angle: CGFloat) -> CATransform3D {
        var transform = CATransform3DMakeRotation(angle, 0, 1, 0)
        
        transform.m34 = CGFloat(-1) / 100
        
        return transform
    }
}
