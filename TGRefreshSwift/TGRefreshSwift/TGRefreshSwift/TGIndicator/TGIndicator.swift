//
//  TGIndicatormanager.swift
//  TGIndicator
//
//  Created by targetcloud on 2017/6/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

public protocol TGIndicatorDelegate {
    func setupAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}

enum TGIndicatorShape {
    case circle
    case circleSemi
    case ring
    case ringTwoHalfVertical
    case ringTwoHalfHorizontal
    case ringThirdFour
    case rectangle
    case triangle
    case line
    case pacman
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        switch self {
        case .circle:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            layer.fillColor = color.cgColor
        case .circleSemi:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-Double.pi / 6),
                        endAngle: CGFloat(-5 * Double.pi / 6),
                        clockwise: false)
            path.close()
            layer.fillColor = color.cgColor
        case .ring:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfVertical:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-3 * Double.pi / 4),
                        endAngle: CGFloat(-Double.pi / 4),
                        clockwise: true)
            path.move(
                to: CGPoint(x: size.width / 2 - size.width / 2 * cos(CGFloat(Double.pi / 4)),
                            y: size.height / 2 + size.height / 2 * sin(CGFloat(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-5 * Double.pi / 4),
                        endAngle: CGFloat(-7 * Double.pi / 4),
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfHorizontal:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(3 * Double.pi / 4),
                        endAngle: CGFloat(5 * Double.pi / 4),
                        clockwise: true)
            path.move(
                to: CGPoint(x: size.width / 2 + size.width / 2 * cos(CGFloat(Double.pi / 4)),
                            y: size.height / 2 - size.height / 2 * sin(CGFloat(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-Double.pi / 4),
                        endAngle: CGFloat(Double.pi / 4),
                        clockwise: true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringThirdFour:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-3 * Double.pi / 4),
                        endAngle: CGFloat(-Double.pi / 4),
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = 2
        case .rectangle:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            layer.fillColor = color.cgColor
        case .triangle:
            let offsetY = size.height / 4
            
            path.move(to: CGPoint(x: 0, y: size.height - offsetY))
            path.addLine(to: CGPoint(x: size.width / 2, y: size.height / 2 - offsetY))
            path.addLine(to: CGPoint(x: size.width, y: size.height - offsetY))
            path.close()
            layer.fillColor = color.cgColor
        case .line:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                cornerRadius: size.width / 2)
            layer.fillColor = color.cgColor
        case .pacman:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 4,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = size.width / 2
        }
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
}

public enum TGIndicatorType: Int {
    case blank
    case ballPulse
    case ballGridPulse
    case ballClipRotate
    case squareSpin
    case ballClipRotatePulse
    case ballClipRotateMultiple
    case ballPulseRise
    case ballRotate
    case cubeTransition
    case ballZigZag
    case ballZigZagDeflect
    case ballTrianglePath
    case ballScale
    case lineScale
    case lineScaleParty
    case ballScaleMultiple
    case ballPulseSync
    case ballBeat
    case lineScalePulseOut
    case lineScalePulseOutRapid
    case ballScaleRipple
    case ballScaleRippleMultiple
    case ballSpinFadeLoader
    case lineSpinFadeLoader
    case triangleSkewSpin
    case pacman
    case ballGridBeat
    case semiCircleSpin
    case ballRotateChase
    case orbit
    case lineCursor
    case squareGridPulse
    case squarePulse
    case windows
    case audioEqualizer
    
    static let allTypes = (blank.rawValue ... audioEqualizer.rawValue).map { TGIndicatorType(rawValue: $0)! }
    
    func animation() -> TGIndicatorDelegate {
        switch self {
        case .blank:
            return TGBlank()
        case .ballPulse:
            return TGBallPulse()
        case .ballGridPulse:
            return TGBallGridPulse()
        case .ballClipRotate:
            return TGBallClipRotate()
        case .squareSpin:
            return TGSquareSpin()
        case .ballClipRotatePulse:
            return TGBallClipRotatePulse()
        case .ballClipRotateMultiple:
            return TGBallClipRotateMultiple()
        case .ballPulseRise:
            return TGBallPulseRise()
        case .ballRotate:
            return TGBallRotate()
        case .cubeTransition:
            return TGCubeTransition()
        case .ballZigZag:
            return TGBallZigZag()
        case .ballZigZagDeflect:
            return TGBallZigZagDeflect()
        case .ballTrianglePath:
            return TGBallTrianglePath()
        case .ballScale:
            return TGBallScale()
        case .lineScale:
            return TGLineScale()
        case .lineScaleParty:
            return TGLineScaleParty()
        case .ballScaleMultiple:
            return TGBallScaleMultiple()
        case .ballPulseSync:
            return TGBallPulseSync()
        case .ballBeat:
            return TGBallBeat()
        case .lineScalePulseOut:
            return TGLineScalePulseOut()
        case .lineScalePulseOutRapid:
            return TGLineScalePulseOutRapid()
        case .ballScaleRipple:
            return TGBallScaleRipple()
        case .ballScaleRippleMultiple:
            return TGBallScaleRippleMultiple()
        case .ballSpinFadeLoader:
            return TGBallSpinFadeLoader()
        case .lineSpinFadeLoader:
            return TGLineSpinFadeLoader()
        case .triangleSkewSpin:
            return TGTriangleSkewSpin()
        case .pacman:
            return TGPacman()
        case .ballGridBeat:
            return TGBallGridBeat()
        case .semiCircleSpin:
            return TGSemiCircleSpin()
        case .ballRotateChase:
            return TGBallRotateChase()
        case .orbit:
            return TGOrbit()
        case .audioEqualizer:
            return TGAudioEqualizer()
        case .lineCursor:
            return TGLineCursor()
        case .squareGridPulse:
            return TGSquareGridPulse()
        case .squarePulse:
            return TGSquarePulse()
        case .windows:
            return TGWindows()
        }
    }
}

public final class TGIndicatorData {
    let size: CGSize
    let message: String?
    let messageFont: UIFont
    let type: TGIndicatorType
    let color: UIColor
    let textColor: UIColor
    let padding: CGFloat
    let displayTimeThreshold: Int
    let minimumDisplayTime: Int
    let backgroundColor: UIColor
    
    public init(size: CGSize? = nil,
                message: String? = nil,
                messageFont: UIFont? = nil,
                type: TGIndicatorType? = nil,
                color: UIColor? = nil,
                padding: CGFloat? = nil,
                displayTimeThreshold: Int? = nil,
                minimumDisplayTime: Int? = nil,
                backgroundColor: UIColor? = nil,
                textColor: UIColor? = nil) {
        self.size = size ?? TGIndicatorView.DEFAULT_BLOCKER_SIZE
        self.message = message ?? TGIndicatorView.DEFAULT_BLOCKER_MESSAGE
        self.messageFont = messageFont ?? TGIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT
        self.type = type ?? TGIndicatorView.DEFAULT_TYPE
        self.color = color ?? TGIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? TGIndicatorView.DEFAULT_PADDING
        self.displayTimeThreshold = displayTimeThreshold ?? TGIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD
        self.minimumDisplayTime = minimumDisplayTime ?? TGIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME
        self.backgroundColor = backgroundColor ?? TGIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR
        self.textColor = textColor ?? color ?? TGIndicatorView.DEFAULT_TEXT_COLOR
    }
}

public final class TGIndicatorView: UIView {
    public static var DEFAULT_TYPE: TGIndicatorType = .ballSpinFadeLoader
    public static var DEFAULT_COLOR = UIColor.white
    public static var DEFAULT_TEXT_COLOR = UIColor.white
    public static var DEFAULT_PADDING: CGFloat = 0
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 40, height: 40)
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    public static var DEFAULT_BLOCKER_MESSAGE: String?
    public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 15)
    public static var DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    public var type: TGIndicatorType = TGIndicatorView.DEFAULT_TYPE
    
    @available(*, unavailable, message: "This property is reserved for IB. Use 'type' instead.")
    @IBInspectable var typeName: String {
        get {
            return getTypeName()
        }
        set {
            _setTypeName(newValue)
        }
    }
    
    @IBInspectable public var color: UIColor = TGIndicatorView.DEFAULT_COLOR
    
    @IBInspectable public var padding: CGFloat = TGIndicatorView.DEFAULT_PADDING
    
    private(set) public var isAnimating: Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    public init(frame: CGRect,
                type: TGIndicatorType? = nil,
                color: UIColor? = nil,
                padding: CGFloat? = nil) {
        self.type = type ?? TGIndicatorView.DEFAULT_TYPE
        self.color = color ?? TGIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? TGIndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
        isHidden = true
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation()
    }
    
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.speed = 0
        layer.sublayers?.removeAll()
    }
    
    func _setTypeName(_ typeName: String) {
        for item in TGIndicatorType.allTypes {
            if String(describing: item).caseInsensitiveCompare(typeName) == ComparisonResult.orderedSame {
                type = item
                break
            }
        }
    }
    
    func getTypeName() -> String {
        return String(describing: type)
    }
    
    private final func setupAnimation() {
        let animation: TGIndicatorDelegate = type.animation()
        
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        
        self.layer.sublayers = nil
        animation.setupAnimation(in: self.layer, size: animationRect.size, color: color)
    }
}

public final class TGIndicatorManager {
    private enum State {
        case waitingToShow
        case showed
        case waitingToHide
        case hidden
    }
    
    private let restorationIdentifier = "restorationIdentifier"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var state: State = .hidden
    
    private let startAnimatingGroup = DispatchGroup()
    
    public static let shared = TGIndicatorManager()
    
    private init() {}
    
    public final func startAnimating(_ data: TGIndicatorData) {
        guard state == .hidden else { return }
        state = .waitingToShow
        startAnimatingGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(data.displayTimeThreshold)) {
            guard self.state == .waitingToShow else {
                self.startAnimatingGroup.leave()
                return
            }
            self.show(with: data)
            self.startAnimatingGroup.leave()
        }
    }
    
    public final func stopAnimating() {
        _hide()
    }
    
    public final func setMessage(_ message: String?) {
        guard state == .showed else {
            startAnimatingGroup.notify(queue: DispatchQueue.main) {
                self.messageLabel.text = message
            }
            return
        }
        messageLabel.text = message
    }
    
    private func show(with activityData: TGIndicatorData) {
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = activityData.backgroundColor
        containerView.restorationIdentifier = restorationIdentifier
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicator = TGIndicatorView(
            frame: CGRect(x: 0, y: 0, width: activityData.size.width, height: activityData.size.height),
            type: activityData.type,
            color: activityData.color,
            padding: activityData.padding)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(indicator)
        
        containerView.addConstraints([NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
                                      NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)])
        
        messageLabel.font = activityData.messageFont
        messageLabel.textColor = activityData.textColor
        messageLabel.text = activityData.message
        containerView.addSubview(messageLabel)
        
        containerView.addConstraints([NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: containerView , attribute: .leading, multiplier: 1, constant: -8),
                                      NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 8),
                                      NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: indicator, attribute: .bottom, multiplier: 1, constant: 8)])
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        keyWindow.addSubview(containerView)
        state = .showed
        
        keyWindow.addConstraints([NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: keyWindow, attribute: .leading, multiplier: 1, constant: 0),
                                  NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: keyWindow, attribute: .trailing, multiplier: 1, constant: 0),
                                  NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: keyWindow, attribute: .top, multiplier: 1, constant: 0),
                                  NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: keyWindow, attribute: .bottom, multiplier: 1, constant: 0)])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(activityData.minimumDisplayTime)) {
            self._hide()
        }
    }
    
    private func _hide() {
        if state == .waitingToHide {
            hide()
        } else if state != .hidden {
            state = .waitingToHide
        }
    }
    
    private func hide() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        for item in keyWindow.subviews
            where item.restorationIdentifier == restorationIdentifier {
                item.removeFromSuperview()
        }
        state = .hidden
    }
}

public protocol TGIndicatorViewable {}

public extension TGIndicatorViewable where Self: UIViewController {
    public final func startAnimating(
        _ size: CGSize? = nil,
        message: String? = nil,
        messageFont: UIFont? = nil,
        type: TGIndicatorType? = nil,
        color: UIColor? = nil,
        padding: CGFloat? = nil,
        displayTimeThreshold: Int? = nil,
        minimumDisplayTime: Int? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil) {
        let activityData = TGIndicatorData(size: size,
                                        message: message,
                                        messageFont: messageFont,
                                        type: type,
                                        color: color,
                                        padding: padding,
                                        displayTimeThreshold: displayTimeThreshold,
                                        minimumDisplayTime: minimumDisplayTime,
                                        backgroundColor: backgroundColor,
                                        textColor: textColor)
        TGIndicatorManager.shared.startAnimating(activityData)
    }
    
    public final func stopAnimating() {
        TGIndicatorManager.shared.stopAnimating()
    }
}


