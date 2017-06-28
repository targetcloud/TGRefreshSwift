//
//  TGLineOrderbyAsc.swift
//  TGRefreshSwift
//
//  Created by targetcloud on 2017/6/28.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGLineOrderbyAsc: TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / 7
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2 + size.height * 0.2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.4, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        for i in 0 ..< 3 {
            let line = TGIndicatorShape.line.layerWith(size: CGSize(width: size.height * 0.3 + lineSize * CGFloat(i), height: lineSize), color: color)
            let frame = CGRect(x: x + lineSize * 0.5 * CGFloat(3 - i),
                               y: y + lineSize * 2 * CGFloat(i),
                               width: size.height * 0.3 + lineSize * CGFloat(i),
                               height: lineSize)
            
            animation.beginTime = beginTime + beginTimes[i]
            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}
