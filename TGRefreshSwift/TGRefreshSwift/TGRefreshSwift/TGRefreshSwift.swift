//
//  TGRefreshSwift.swift
//  TGRefreshSwift
//
//  Created by targetcloud on 2017/6/22.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  https://github.com/targetcloud/TGRefreshSwift

import UIKit

public enum TGRefreshState: Int {
    case Normal = 0
    case Pulling
    case Refreshing
}

public enum TGRefreshKind: Int {
    case QQ = 0
    case Common
}

public enum TGRefreshAlignment: Int {
    case Top = 0
    case Midden
    case Bottom
}

open class TGRefreshSwift: UIControl {
    
    fileprivate var refreshHeight: CGFloat = 40//起始高度，通过构造进来，只有一次机会设置
    fileprivate let kDragHeight: CGFloat = 90.0
    fileprivate var kCenter: CGPoint {//测试 let 不准
        return CGPoint(x: self.bounds.size.width * 0.5, y: refreshHeight * 0.5)
    }
    fileprivate let kRadius: CGFloat  = 15.0
    fileprivate let kCoefficient: CGFloat = 0.6
    fileprivate let kScreenH = UIScreen.main.bounds.size.height
    
    fileprivate var deltaH: CGFloat = 0
    fileprivate var animating:Bool = false
    fileprivate var refreshing:Bool = false
    fileprivate var initInsetTop:CGFloat = 0
    fileprivate var bgImageView: UIImageView?{//通过构造进来，只有一次机会设置
        didSet{
            if bgImageView != nil{
                insertSubview(bgImageView!, at: 0)
                bgImageView?.alpha = 0.5
                bgImageView?.translatesAutoresizingMaskIntoConstraints = false
                addConstraint(NSLayoutConstraint(item: bgImageView!,attribute: .left,relatedBy: .equal,toItem: self,attribute: .left,multiplier: 1.0,constant: 0))
                addConstraint(NSLayoutConstraint(item: bgImageView!,attribute: .right,relatedBy: .equal,toItem: self,attribute: .right,multiplier: 1.0,constant: 0))
                addConstraint(NSLayoutConstraint(item: bgImageView!,attribute: .bottom,relatedBy: .equal,toItem: self,attribute: .bottom,multiplier: 1.0,constant: 0))
            }
        }
    }
    //fileprivate var tipLabelCenterYConstraint: NSLayoutConstraint?//废弃
    fileprivate var tipLabelBottomConstraint: NSLayoutConstraint?//默认控件高度一半
    fileprivate var indicatorRightConstraint: NSLayoutConstraint?//往左偏margin -
    fileprivate var tipLabelCenterXConstraint: NSLayoutConstraint?//往右偏margin +
    fileprivate var tipIndicatorRightConstraint: NSLayoutConstraint?
    
    /** 刷新中的指示器类型 */
    public var indicatorRefreshingStyle: TGIndicatorType = .lineCursor
    
    /** 刷新前的指示器类型 */
    public var indicatorNormalStyle: TGIndicatorType = .lineOrderbyAsc
    
    /** 刷新失败时的提示器样式 */
    public var tipFailStyle: TGIndicatorType = .ballScaleMultiple
    
    /** 刷新失败时的提示器颜色 */
    public var tipFailColor: UIColor = .red
    
    /** 刷新成功时的提示器样式 */
    public var tipOKStyle: TGIndicatorType = .ballScaleMultiple
    
    /** 刷新成功时的提示器颜色 */
    public var tipOKColor: UIColor = .green
    
    /** 忽略初始的InsetTop,用于刷新控件所画的位置进行定位 */
    public var ignoreScrollViewContentInsetTop: Bool = false
    
    /** 各元素间边界 */
    public var margin: CGFloat = 10{
        didSet{
            //更新约束
            indicatorRightConstraint?.constant = -margin
            tipLabelCenterXConstraint?.constant = margin
            tipIndicatorRightConstraint?.constant = -margin
        }
    }
    
    /** 类型，默认为QQ弹簧 皮筋效果 */
    public var kind: TGRefreshKind = .QQ
    
    /** 主题色（状态提示文字颜色（不包含结果提示）、ActivityIndicator颜色、橡皮筯颜色） */
    public var tinColor : UIColor = .gray{
        didSet{
            indicator.color = tinColor
            tipLabel.textColor = tinColor
        }
    }
    
    /** 背景色 */
    public var bgColor: UIColor?{
        didSet{
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            bgColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
            self.bgColor = UIColor(colorLiteralRed: Float(r), green: Float(g), blue: Float(b), alpha: 1)
            self.backgroundColor = self.bgColor
        }
    }
    /** 垂直对齐，默认顶部 */
    public var verticalAlignment: TGRefreshAlignment = .Top
    
    /** 是否显示刷新成功或失败 */
    public var isShowSuccesOrFailInfo: Bool = true
    
    /** 是否刷新成功 在第二次刷新前自动置为true */
    public var isSuccess: Bool = true
    
    /** 刷新失败时的提示文字 */
    public var refreshFailStr: String = "刷新失败"{
        didSet{
            refreshFailStr = refreshFailStr == "" ? " " : refreshFailStr
        }
    }
    
    /** 刷新成功时的提示文字 */
    public var refreshSuccessStr: String = "刷新成功" {
        didSet{
            refreshSuccessStr = refreshSuccessStr == "" ? " " : refreshSuccessStr
        }
    }
    
    /** 准备刷新时的提示文字 */
    public var refreshNormalStr: String = "下拉可以刷新"
    
    /** 即将刷新时的提示文字 */
    public var refreshPullingStr: String = "松开立即刷新"
    
    /** 正在刷新时的提示文字 */
    public var refreshingStr: String = "正在刷新数据中..."{
        didSet{
            refreshingStr = refreshingStr == "" ? " " : refreshingStr
        }
    }
    
    /** 更新结果的回显文字 */
    public var refreshResultStr: String = ""
    
    /** 更新结果的回显背景色 */
    public var refreshResultBgColor: UIColor = UIColor.gray.withAlphaComponent(0.8){
        didSet{
            if self.sv != nil{
                self.resultLabel.backgroundColor = refreshResultBgColor
            }
        }
    }
    
    /** 更新结果的回显文字颜色 */
    public var refreshResultTextColor: UIColor = .white{
        didSet{
            if self.sv != nil{
                self.resultLabel.textColor = refreshResultTextColor
            }
        }
    }
    
    /** 更新结果的回显高度 */
    public var refreshResultHeight: CGFloat = 34
    
    /** 自动改变透明度，默认已做优化 */
    public var automaticallyChangeAlpha: Bool = false
    
    /** 回显时的渐显时间 0.1 ～ 2秒 默认0.5 */
    public var fadeinTime: CGFloat = 0.5{
        didSet{
            fadeinTime =  fadeinTime < 0.1 ? 0.1 : ((fadeinTime > 2) ? 2 : fadeinTime)
        }
    }
    
    /** 回显时的渐隐时间 0.1 ～ 5秒 默认1.5 */
    public var fadeoutTime: CGFloat = 1.5{
        didSet{
            fadeoutTime = fadeoutTime < 0.1 ? 0.1 : ((fadeoutTime > 5) ? 5 : fadeoutTime)
        }
    }
    
    /** 提示文字字体大小 9 ～ 20 默认11 */
    public var tipLabelFontSize: CGFloat = 11{
        didSet{
            tipLabelFontSize = tipLabelFontSize < 9 ? 9 : ((tipLabelFontSize > 20) ? 20 : tipLabelFontSize)
            self.tipLabel.font = UIFont.systemFont(ofSize: tipLabelFontSize)
        }
    }
    
    /** 结果文字字体大小 9 ～ 20 默认12 */
    public var resultLabelFontSize: CGFloat = 12{
        didSet{
            resultLabelFontSize = resultLabelFontSize < 9 ? 9 : ((resultLabelFontSize > 20) ? 20 : resultLabelFontSize)
        }
    }
    
    private weak var sv: UIScrollView?
    
    //normal
    private lazy var tipIndicator: TGIndicatorView = {
        let tipindicator = TGIndicatorView(frame:CGRect(x: 0, y: 0, width: self.refreshHeight * 0.5, height: self.refreshHeight * 0.5),
                                           type:self.indicatorNormalStyle,
                                           color:self.tinColor)
        tipindicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        tipindicator.isHidden = true
        self.addSubview(tipindicator)
        return tipindicator
    }()
    
    private lazy var tipLabel: UILabel = {
        let tipLabel =  UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: self.tipLabelFontSize)
        tipLabel.text = self.refreshNormalStr
        tipLabel.backgroundColor = UIColor.clear
        tipLabel.textColor = self.tinColor
        self.addSubview(tipLabel)
        return tipLabel
    }()
    
    private lazy var resultLabel: UILabel = {
        let resultLabel =  UILabel()
        resultLabel.font = UIFont.systemFont(ofSize: self.resultLabelFontSize)
        resultLabel.textAlignment = .center
        resultLabel.text = self.refreshResultStr
        resultLabel.backgroundColor = self.refreshResultBgColor
        resultLabel.textColor = self.refreshResultTextColor
        resultLabel.frame = CGRect(x: self.sv!.frame.origin.x,
                                   y: self.ignoreScrollViewContentInsetTop ? 0 : -self.initInsetTop,
                                   width: self.sv!.frame.size.width,
                                   height: self.refreshResultHeight)
        self.sv?.addSubview(resultLabel)
        return resultLabel
    }()
    
    //refreshing
    private lazy var indicator:TGIndicatorView = {
        let indicator = TGIndicatorView(frame:CGRect(x: 0, y: 0, width: self.refreshHeight * 0.5, height: self.refreshHeight * 0.5),
                                        type:self.indicatorRefreshingStyle,
                                        color:self.tinColor)
        self.addSubview(indicator)
        //self.insertSubview(indicator, at: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: indicator,attribute: .centerY,relatedBy: .equal,toItem: self.tipLabel,attribute: .centerY,multiplier: 1.0,constant: 0))
        self.indicatorRightConstraint = NSLayoutConstraint(item: indicator,attribute: .right,relatedBy: .equal,toItem: self.tipLabel,attribute: .left,multiplier: 1.0,constant: -self.margin)
        self.addConstraint(self.indicatorRightConstraint!)
        return indicator
    }()
    
    private lazy var tipResultSuccessOrFailIndicator:TGIndicatorView = {
        let tipindicator = TGIndicatorView(frame:CGRect(x: 0, y: 0, width: self.refreshHeight * 0.5, height: self.refreshHeight * 0.5))
        self.addSubview(tipindicator)
        //self.insertSubview(tipindicator, at: 0)
        tipindicator.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: tipindicator,attribute: .centerY,relatedBy: .equal,toItem: self.indicator,attribute: .centerY,multiplier: 1.0,constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tipindicator,attribute: .centerX,relatedBy: .equal,toItem: self.indicator,attribute: .centerX,multiplier: 1.0,constant: 0))
        return tipindicator
    }()
    
    private lazy var innerImageView: UIImageView = {
        let iv = UIImageView(image: self.getImage("refresh@2x"))
        iv.isHidden = true
        self.addSubview(iv)
        return iv
    }()
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let fatherView = newSuperview as? UIScrollView {
            self.initInsetTop = fatherView.contentInset.top
            self.sv = fatherView
            self.backgroundColor = self.bgColor ?? self.sv?.backgroundColor
            //self.backgroundColor = randomColor()//测试代码
            self.frame = CGRect(x: 0,
                                y: self.ignoreScrollViewContentInsetTop  ? -refreshHeight : -refreshHeight-initInsetTop,
                                width: fatherView.bounds.width,
                                height:refreshHeight)
            self.clipsToBounds = true
            fatherView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)//options: []
        }
    }
    
    fileprivate var refreshState: TGRefreshState = .Normal {
        didSet {
            switch self.kind {
            case .QQ:
                switch refreshState {
                case .Refreshing:
                    if (!animating){
                        animating = true
                        UIView.animate(withDuration: 0.125, animations: {
                            self.sv?.contentInset.top += self.refreshHeight
                        })
                        UIView.animate(withDuration: 0.125, animations: {
                            self.innerImageView.isHidden = true
                            self.deltaH = -self.kScreenH
                            self.setNeedsDisplay()
                        }, completion: { (_) in
                            self.animating = false
                            self.refreshing = true
                            self.sv?.contentOffset = CGPoint(x: 0, y: -(self.refreshHeight + self.initInsetTop))
                            self.tipLabel.text = self.refreshingStr
                            self.tipLabel.isHidden = false
                            self.tipIndicator.isHidden = true
                            self.indicator.type = self.indicatorRefreshingStyle
                            self.indicator.startAnimating()
                        })
                        self.sendActions(for: .valueChanged)
                    }
                case .Normal:
                    tipLabel.text = self.refreshNormalStr
                    tipIndicator.isHidden = true
                    tipLabel.isHidden = true
                    indicator.stopAnimating()
                    if oldValue == .Refreshing {
                        self.sv?.contentInset.top -= refreshHeight
                        self.sv?.contentOffset = CGPoint(x: 0, y: -initInsetTop)
                    }
                default:
                    break
                }
                
            case .Common:
                self.tipIndicator.sizeToFit()
                switch refreshState {
                case .Normal:
                    tipLabel.text = self.refreshNormalStr
                    tipIndicator.isHidden = oldValue == .Refreshing ? true : false
                    tipLabel.isHidden = oldValue == .Refreshing ? true : false
                    indicator.stopAnimating()
                    if oldValue == .Refreshing {
                        self.sv?.contentInset.top -= refreshHeight
                        self.sv?.contentOffset = CGPoint(x: 0, y: -initInsetTop)
                    }
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tipIndicator.transform = CGAffineTransform.identity
                    })
                case .Pulling:
                    tipLabel.text = self.refreshPullingStr
                    tipIndicator.isHidden = false
                    tipLabel.isHidden = false
                    indicator.stopAnimating()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.tipIndicator.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi + 0.001))
                    })
                case .Refreshing:
                    tipLabel.text = self.refreshingStr
                    tipLabel.isHidden = false
                    tipIndicator.isHidden = true
                    indicator.type = self.indicatorRefreshingStyle
                    indicator.startAnimating()
                    self.sv?.contentInset.top += self.refreshHeight
                    UIView .animate(withDuration: 0.25, animations: {
                        self.sv?.contentOffset = CGPoint(x: 0, y: -(self.initInsetTop+self.refreshHeight))
                    })
                    self.sendActions(for: .valueChanged)
                }
                //            default:
                //                break
            }
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollview = self.sv ,keyPath == "contentOffset" else {
            return
        }
        let offsetY = scrollview.contentOffset.y
        let height = -(self.initInsetTop + offsetY)
        if height < 0 {
            return
        }
        self.frame = CGRect(x: 0,
                            y: self.ignoreScrollViewContentInsetTop  ? -height : -height-self.initInsetTop,
                            width: scrollview.bounds.width,
                            height:height)//拉多少高控件就变成多少高
        let targetY: CGFloat = -(scrollview.contentInset.top + refreshHeight)
        //print ("<---刷新控件 contentInsetTop>\(scrollview.contentInset.top)<  height>\(height)<   offsetY>\(offsetY)<    targetY>\(targetY)<    refreshState>\(refreshState)< ---")
        
        switch self.kind {
        case .QQ:
            if self.animating || self.refreshing || self.refreshState == .Refreshing {
                return
            }
            deltaH = CGFloat(fmaxf(0, Float(-offsetY - refreshHeight - initInsetTop)))
            self.innerImageView.isHidden = false
            self.setNeedsDisplay()
            if -offsetY > kDragHeight + initInsetTop {
                self.beginRefreshing()
            }
            
        case .Common:
            if self.refreshState == .Refreshing {
                return
            }
            if scrollview.isDragging {
                if  refreshState == .Normal && offsetY < targetY {//height > refreshHeight
                    refreshState = .Pulling
                } else if refreshState == .Pulling && offsetY > targetY {//height <= refreshHeight
                    refreshState = .Normal
                } else if height <= refreshHeight {
                    self.refreshState = .Normal
                }
            } else {
                if refreshState == .Pulling {
                    //refreshState = .Refreshing
                    self.beginRefreshing()
                }
            }
            
            self.tipLabel.alpha = self.automaticallyChangeAlpha ? (height/refreshHeight) :
                (self.verticalAlignment == .Top ? (height/refreshHeight) : 1)
            self.tipIndicator.alpha = self.tipLabel.alpha
            self.setNeedsDisplay()
            
            //        default:
            //TODO:- 扩展其他样式
            //            break
        }
    }
    
    public func beginRefreshing() {
        //print("<---刷新控件 beginRefreshing 开始刷新")
        guard self.sv != nil else {
            return
        }
        if refreshState == .Refreshing {
            return
        }
        refreshState = .Refreshing
    }
    
    public func endRefreshing() {
        //print("<---刷新控件 endRefreshing 结束刷新")
        guard self.sv != nil else {
            return
        }
        if refreshState == .Refreshing {
            self.tipIndicator.transform =  CGAffineTransform.identity
            self.tipIndicator.isHidden = true
            refreshing = false
            animating = false
            self.tipLabel.text = self.isSuccess ? self.refreshSuccessStr : self.refreshFailStr
            self.tipLabel.text = self.isShowSuccesOrFailInfo ? self.tipLabel.text : " "
            
            self.tipLabel.sizeToFit()
            
            if tipLabel.text == " "{
                tipLabelCenterXConstraint?.constant = margin * 2
            }
            
            self.indicator.stopAnimating()
            
            self.tipLabel.isHidden = !self.isShowSuccesOrFailInfo
            self.tipResultSuccessOrFailIndicator.isHidden = !self.isShowSuccesOrFailInfo
            
            self.tipLabel.alpha = 0.5
            self.tipResultSuccessOrFailIndicator.type = self.isSuccess ? self.tipOKStyle : tipFailStyle
            self.tipResultSuccessOrFailIndicator.color = self.isSuccess ? self.tipOKColor : self.tipFailColor
            self.tipResultSuccessOrFailIndicator.startAnimating()
            UIView .animate(withDuration: self.isShowSuccesOrFailInfo ? 0.75 : 0.25, animations: {
                if self.isShowSuccesOrFailInfo{
                    self.tipLabel.alpha = 1
                }//else{
                    //self.tipLabelCenterXConstraint?.constant = self.tipLabel.frame.size.width * 0.5 + self.margin * 2
                //}
            }) { (_) in
                UIView .animate(withDuration: 0.25, animations: {
                    self.tipResultSuccessOrFailIndicator.stopAnimating()
                    self.tipResultSuccessOrFailIndicator.isHidden = true
                    self.tipLabel.isHidden = true
                }, completion: { (_) in
                    //print("<---刷新控件 completion refreshState>\(self.refreshState)")
                    if self.refreshState == .Refreshing {
                        self.refreshState = .Normal
                        if (self.refreshResultStr.characters.count > 0){
                            self.resultLabel.font = UIFont.systemFont(ofSize: self.resultLabelFontSize)
                            self.resultLabel.alpha = 0
                            self.resultLabel.transform = CGAffineTransform(translationX: 0, y: -self.refreshResultHeight)
                            self.resultLabel.text = self.refreshResultStr
                            
                            UIView.animate(withDuration: TimeInterval(self.fadeinTime), animations: {
                                self.resultLabel.transform = CGAffineTransform.identity
                                self.resultLabel.alpha = 1
                            }, completion: { (_) in
                                UIView.animate(withDuration: TimeInterval(self.fadeoutTime), animations: {
                                    self.resultLabel.transform = CGAffineTransform(translationX: 0, y: -self.refreshResultHeight)
                                    self.resultLabel.alpha = 0
                                    self.refreshResultStr = ""
                                    self.tipLabelCenterXConstraint?.constant = self.margin
                                    self.isSuccess = true
                                    self.tipLabel.alpha = 1
                                })
                            })
                        }else{
                            self.refreshResultStr = ""
                            self.tipLabelCenterXConstraint?.constant = self.margin
                            self.isSuccess = true
                            self.tipLabel.alpha = 1
                        }
                    }
                })
            }
        }
    }
    
    override open func removeFromSuperview() {//removeFromSuperview 与 deinit共存是否有问题，待测试
        //superview?.removeObserver(self, forKeyPath: "contentOffset")
        self.sv?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    deinit {
        self.sv?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override init(frame: CGRect) {//只是高度值有效，存成员属性refreshHeight
        self.refreshHeight = frame.size.height
        refreshHeight = CGFloat(fmaxf(40, Float(refreshHeight)))
        //        let rect = CGRect(x: 0, y: -refreshHeight, width: UIScreen.main.bounds.width, height: refreshHeight)
        //        super.init(frame: rect)
        super.init(frame: CGRect())//上面代码不用，在KVO实时改变控件的大小
        setupUI()
    }
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    convenience init(_ target: Any? = nil, _ action: Selector? = nil, _ config:((_ refresh:TGRefreshSwift)->())?){
        self.init()
        config?(self)
        if target != nil && action != nil{
            self.addTarget(target, action: action!, for: .valueChanged)
        }
    }
    
    public class func refresh(_ target: Any? = nil, _ action: Selector? = nil, _ height:CGFloat = 40 , _ bgImageView: UIImageView? = nil, _ config:((_ refresh:TGRefreshSwift)->())? = nil) -> TGRefreshSwift{
        let refresh = TGRefreshSwift(target,action,config)
        refresh.refreshHeight = height
        refresh.bgImageView = bgImageView
        return refresh
    }
    
    private func setupUI(){
        //加约束，不能依赖第三方库，KVO时改变锚点（tipLabel）约束
        //        for v in subviews {
        //            v.translatesAutoresizingMaskIntoConstraints = false
        //        }
        
        //先调用懒加载
        self.tipLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tipIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        //提示文本
        tipLabelCenterXConstraint = NSLayoutConstraint(item: self.tipLabel,attribute: .centerX,relatedBy: .equal,toItem: self,attribute: .centerX,multiplier: 1.0,constant: margin)
        addConstraint(tipLabelCenterXConstraint!)
        tipLabelBottomConstraint = NSLayoutConstraint(item: self.tipLabel,attribute: .bottom,relatedBy: .equal,toItem: self,attribute: .bottom,multiplier: 1.0,constant: -refreshHeight * 0.5)
        addConstraint(tipLabelBottomConstraint!)
        
        //        tipLabelCenterYConstraint = NSLayoutConstraint(item: self.tipLabel,attribute: .centerY,relatedBy: .equal,toItem: self,attribute: .centerY,multiplier: 1.0,constant: 0)
        //        addConstraint(tipLabelCenterYConstraint!)
        
        tipIndicatorRightConstraint = NSLayoutConstraint(item: self.tipIndicator,attribute: .right,relatedBy: .equal,toItem: self.tipLabel,attribute: .left,multiplier: 1.0,constant: -self.margin)
        addConstraint(tipIndicatorRightConstraint!)
        addConstraint(NSLayoutConstraint(item: self.tipIndicator,attribute: .centerY,relatedBy: .equal,toItem: self.tipLabel,attribute: .centerY,multiplier: 1.0,constant: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func getImage(_ name:String) -> UIImage{
        let currentBundle = Bundle(path: Bundle(for: TGRefreshSwift.self).path(forResource: "TGRefreshSwift", ofType: "bundle")!)
        return UIImage(contentsOfFile: (currentBundle?.path(forResource: name, ofType: "png"))!)!
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.tipLabel.sizeToFit()
        
        switch self.kind {
        case .QQ:
            self.alpha = self.frame.size.height/refreshHeight
        case .Common:
            break
        }
        
        switch self.verticalAlignment {
        case .Top:
            self.tipLabelBottomConstraint?.constant = -(self.frame.size.height - refreshHeight * 0.5) + margin * 0.5
        case .Midden:
            self.tipLabelBottomConstraint?.constant = -(self.frame.size.height - refreshHeight * 0.5) * 0.5 - margin * 0.5
        case .Bottom:
            self.tipLabelBottomConstraint?.constant = -(margin)
        }
    }
    
    //橡皮筋等样式需要自己绘制的情况下用
    override open func draw(_ rect: CGRect) {
        switch (self.kind) {
        case .QQ:
            break
        default:
            tipIndicator.color = self.tinColor
            tipIndicator.type = self.indicatorNormalStyle
            if !tipIndicator.isHidden && !tipIndicator.isAnimating{
                tipIndicator.startAnimating()
            }
            return
        }
        
        if (refreshing || self.innerImageView.isHidden) {
            return
        }
        
        let startCenter: CGPoint  = self.kCenter
        
        deltaH = (deltaH > (kDragHeight - refreshHeight)) ? (kDragHeight - refreshHeight) : deltaH
        
        let radTop: CGFloat  = kRadius - deltaH * 0.1
        let radBottom: CGFloat  = kRadius - deltaH * 0.2
        
        if (deltaH == -kScreenH){
            let circle: UIBezierPath = UIBezierPath(arcCenter: startCenter, radius: 0, startAngle: 0, endAngle: CGFloat(2*(Double.pi)), clockwise: true)
            self.tinColor.setFill()
            circle.fill()
            return
        }
        
        let Y: CGFloat  = CGFloat(fmaxf(Float(deltaH), 0))
        
        var radBottomLeftAndRight: CGFloat  = 0
        if (radTop - radBottom) > 0 {
            radBottomLeftAndRight = (pow(Y, 2)+pow(radBottom, 2)-pow(radTop, 2))/(2*(radTop - radBottom))
        }
        radBottomLeftAndRight = fmax(0, radBottomLeftAndRight)
        
        let centerBottom: CGPoint  = relative(startCenter, 0, Y)
        let centerRight: CGPoint  = relative(centerBottom, radBottom+radBottomLeftAndRight, 0)
        let centerLeft: CGPoint  = relative(centerBottom, -radBottom-radBottomLeftAndRight, 0)
        
        self.innerImageView.bounds = CGRect(x: 0, y: 0, width: radTop * 2 * kCoefficient, height: radTop * 2 * kCoefficient)
        self.innerImageView.center = kCenter
        
        let circle: UIBezierPath = UIBezierPath(arcCenter: startCenter, radius: radTop, startAngle: 0, endAngle: CGFloat(2*(Double.pi)), clockwise: true)
        if deltaH <= 0 {
            self.tinColor.setFill()
            circle.fill()
            return
        }
        
        circle.move(to: centerBottom)
        circle.addArc(withCenter: centerBottom, radius: radBottom, startAngle: 0, endAngle: CGFloat(2*(Double.pi)), clockwise: true)
        
        let circle2: UIBezierPath = UIBezierPath(arcCenter: centerRight, radius: radBottomLeftAndRight, startAngle: 0, endAngle: CGFloat(2*(Double.pi)), clockwise: true)
        circle2.move(to: centerLeft)
        circle2.addArc(withCenter: centerLeft, radius: radBottomLeftAndRight, startAngle: 0, endAngle: CGFloat(2*(Double.pi)), clockwise: true)
        
        
        let line: UIBezierPath = UIBezierPath()
        
        line.move(to: startCenter)
        line.addLine(to: centerRight)
        line.addLine(to: centerBottom)
        line.addLine(to: centerLeft)
        line.close()
        line.append(circle)
        self.tinColor.setFill()
        line.fill()
        (self.bgColor ?? (self.backgroundColor)!).setFill()
        circle2.fill()
    }
    
    fileprivate func relative(_ point: CGPoint , _ x: CGFloat, _ y: CGFloat) -> CGPoint{
        return CGPoint(x: point.x + x, y: point.y + y)
    }
    
    //测试代码
    private func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    //链式配置相关,共28个
    @discardableResult
    public func tg_kind(_ kind: TGRefreshKind) -> TGRefreshSwift{
        self.kind = kind
        return self
    }
    
    @discardableResult
    public func tg_bgColor(_ color: UIColor) -> TGRefreshSwift {
        self.bgColor = color
        return self
    }
    
    @discardableResult
    public func tg_tinColor(_ color: UIColor) -> TGRefreshSwift {
        self.tinColor = color
        return self
    }
    
    @discardableResult
    public func tg_tipFailColor(_ color: UIColor) -> TGRefreshSwift {
        self.tipFailColor = color
        return self
    }
    
    @discardableResult
    public func tg_tipOKColor(_ color: UIColor) -> TGRefreshSwift {
        self.tipOKColor = color
        return self
    }
    
    @discardableResult
    public func tg_verticalAlignment(_ vl: TGRefreshAlignment) -> TGRefreshSwift {
        self.verticalAlignment = vl
        return self
    }
    
    @discardableResult
    public func tg_refreshSuccessStr(_ str: String) -> TGRefreshSwift {
        self.refreshSuccessStr = str
        return self
    }
    
    @discardableResult
    public func tg_refreshNormalStr(_ str: String) -> TGRefreshSwift {
        self.refreshNormalStr = str
        return self
    }
    
    @discardableResult
    public func tg_refreshPullingStr(_ str: String) -> TGRefreshSwift {
        self.refreshPullingStr = str
        return self
    }
    
    @discardableResult
    public func tg_refreshingStr(_ str: String) -> TGRefreshSwift {
        self.refreshingStr = str
        return self
    }
    
    @discardableResult
    public func tg_refreshResultStr(_ str: String) -> TGRefreshSwift {
        self.refreshResultStr = str
        return self
    }
    
    @discardableResult
    public func tg_refreshResultBgColor(_ color: UIColor) -> TGRefreshSwift {
        self.refreshResultBgColor = color
        return self
    }
    
    @discardableResult
    public func tg_refreshResultTextColor(_ color: UIColor) -> TGRefreshSwift {
        self.refreshResultTextColor = color
        return self
    }
    
    @discardableResult
    public func tg_refreshResultHeight(_ height: CGFloat) -> TGRefreshSwift {
        self.refreshResultHeight = height
        return self
    }
    
    @discardableResult
    public func tg_automaticallyChangeAlpha(_ autoAlpha: Bool) -> TGRefreshSwift {
        self.automaticallyChangeAlpha = autoAlpha
        return self
    }
    
    @discardableResult
    public func tg_fadeinTime(_ time: CGFloat) -> TGRefreshSwift {
        self.fadeinTime = time < 0.1 ? 0.1 : ((time > 2) ? 2 : time)
        return self
    }
    
    @discardableResult
    public func tg_fadeoutTime(_ time: CGFloat) -> TGRefreshSwift {
        self.fadeoutTime = time < 0.1 ? 0.1 : ((time > 5) ? 5 : time)
        return self
    }
    
    @discardableResult
    public func tg_ignoreScrollViewContentInsetTop(_ ignore: Bool) -> TGRefreshSwift {
        self.ignoreScrollViewContentInsetTop = ignore
        return self
    }
    
    @discardableResult
    public func tg_margin(_ margin: CGFloat) -> TGRefreshSwift {
        self.margin = margin
        return self
    }
    
    @discardableResult
    public func tg_tipLabelFontSize(_ size: CGFloat) -> TGRefreshSwift {
        self.tipLabelFontSize = size
        return self
    }
    
    @discardableResult
    public func tg_resultLabelFontSize(_ size: CGFloat) -> TGRefreshSwift {
        self.resultLabelFontSize = size
        return self
    }
    
    @discardableResult
    public func tg_tipFailStyle(_ style: TGIndicatorType) -> TGRefreshSwift {
        self.tipFailStyle = style
        return self
    }
    
    @discardableResult
    public func tg_tipOKStyle(_ style: TGIndicatorType) -> TGRefreshSwift {
        self.tipOKStyle = style
        return self
    }
    
    @discardableResult
    public func tg_indicatorRefreshingStyle(_ style: TGIndicatorType) -> TGRefreshSwift {
        self.indicatorRefreshingStyle = style
        return self
    }

    @discardableResult
    public func tg_indicatorNormalStyle(_ style: TGIndicatorType) -> TGRefreshSwift {
        self.indicatorNormalStyle = style
        return self
    }
    
    @discardableResult
    public func tg_isShowSuccesOrFailInfo(_ show: Bool) -> TGRefreshSwift {
        self.isShowSuccesOrFailInfo = show
        return self
    }
    
    @discardableResult
    public func tg_isSuccess(_ success: Bool) -> TGRefreshSwift {
        self.isSuccess = success
        return self
    }
    
    @discardableResult
    public func tg_refreshFailStr(_ str: String) -> TGRefreshSwift {
        self.refreshFailStr = str
        return self
    }
}

extension UIScrollView{
    private struct AssociatedKeys {
        static var TGRefreshSwiftHeaderKey = "TGRefreshSwiftHeaderKey"
    }
    
    open var tg_header: TGRefreshSwift?{
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.TGRefreshSwiftHeaderKey) as? TGRefreshSwift
        }
        set(newValue) {
            if self.tg_header != newValue{
                self.tg_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.willChangeValue(forKey: "tg_header")
                objc_setAssociatedObject(self, &AssociatedKeys.TGRefreshSwiftHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN)//OBJC_ASSOCIATION_RETAIN_NONATOMIC
                self.didChangeValue(forKey: "tg_header")
            }
            
        }
    }
}
