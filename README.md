<img src="https://github.com/targetcloud/TGRefreshSwift/blob/master/Banners.png" width = "15%" hight = "15%"/>

  ## TGRefreshSwift
弹簧、橡皮筋下拉刷新控件，类似QQ下拉刷新控件，但比QQ 更强，同时支持其他样式，目前总共2种样式，后续不断添加中...

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
![Build](https://img.shields.io/badge/build-passing-green.svg)
![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/Pastel.svg?style=flat)
![Cocoapod](https://img.shields.io/badge/pod-v0.0.1-blue.svg)


## OC version
https://github.com/targetcloud/TGRefreshOC


## Recently Updated
- 0.0.1 TGRefreshOC版本的增强版本，更多参数配置


## Features
- [x] 支持链式编程配置，程序员的最爱
- [x] 支持两种刷新结果提示
- [x] 支持QQ和Common两种下拉刷新样式
- [x] 支持contentInset
- [x] 支持Cocoapods
- [x] 支持MJRefresh到TGRefresh风格切换，只需要把mj_header改为tg_header，改动2个字母即可
- [x] 支持4种配置方式，Ordinary、Simple、Senior、Recommend，推荐使用Recommend配置
- [x] 支持刷新结果回显配置
- [x] 支持刷新结果成功或失败配置
- [x] 超轻量级、使用超灵活、功能超强大
- [x] 用例丰富，快速上手


## Usage

#### 以下tv均指tableview或UIScrollview类型

首先写上这一句
```swift
#import TGRefreshSwift
```
如果需要，在你的控制器中加上一句
```swift
self.automaticallyAdjustsScrollViewInsets=false
```

### QQ效果
```swift
self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior))
```

### 普通效果
```swift
self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior)){(refresh) in
            refresh.tg_kind(.Common)
        }
```

### 更多配置，使用链式编程配置
```swift
    self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior)){(refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_fadeinTime(2)
                .tg_verticalAlignment(.Midden)
                .tg_fadeoutTime(1)
                .tg_bgColor(UIColor(white:0.8,alpha:1))
        }
```

### 开始刷新
```swift
self.tv.tg_header?.beginRefreshing()
```

### （网络请求等情况得到数据后）结束刷新
```swift
self.tv.tg_header?.endRefreshing()
```

### 结束刷新时的回显
```swift
//示例代码
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let isSuccess = arc4random_uniform(3) % 2 == 0
            let count = isSuccess ? arc4random_uniform(20) : 0
            self.dataCount = count>0 ? Int(count) : self.dataCount
            self.tv.tg_header?.refreshResultStr = count>0 ? "成功刷新到\(count)条数据,来自TGRefreshSwift" : "请先在Github上Star本控件:-）"
            self.tv.tg_header?.isSuccess = isSuccess
            isSuccess ? self.tv.reloadData() : ()
            self.tv.tg_header?.endRefreshing()
        }
```

### 可以配置的属性
``` swift
/** 刷新失败时的提示图标 */
public var tipStyle:TGTipStyle = .tipInfoGray
    
/** 忽略初始的InsetTop,用于刷新控件所画的位置进行定位 */
public var ignoreScrollViewContentInsetTop: Bool = false
    
/** 各元素间边界 */
public var margin: CGFloat = 10
    
/** 类型，默认为QQ弹簧 皮筋效果 */
public var kind: TGRefreshKind = .QQ
    
/** 主题色（状态提示文字颜色（不包含结果提示）、ActivityIndicator颜色、橡皮筯颜色） */
public var tinColor : UIColor = .gray
    
/** 背景色 */
public var bgColor: UIColor?

/** 垂直对齐，默认顶部 */
public var verticalAlignment: TGRefreshAlignment = .Top
    
/** 是否显示刷新成功或失败 */
public var isShowSuccesOrFailInfo: Bool = true
    
/** 是否刷新成功 在第二次刷新前自动置为true */
public var isSuccess: Bool = true
    
/** 刷新失败时的提示文字 */
public var refreshFailStr: String = "刷新失败"
    
/** 刷新成功时的提示文字 */
public var refreshSuccessStr: String = "刷新成功" 
    
/** 准备刷新时的提示文字 */
public var refreshNormalStr: String = "下拉可以刷新"
    
/** 即将刷新时的提示文字 */
public var refreshPullingStr: String = "松开立即刷新"
    
/** 正在刷新时的提示文字 */
public var refreshingStr: String = "正在刷新数据中..."
    
/** 更新结果的回显文字 */
public var refreshResultStr: String = ""
    
/** 更新结果的回显背景色 */
public var refreshResultBgColor: UIColor = UIColor.gray.withAlphaComponent(0.8)
    
/** 更新结果的回显文字颜色 */
public var refreshResultTextColor: UIColor = .white
    
/** 更新结果的回显高度 */
public var refreshResultHeight: CGFloat = 34
    
/** 自动改变透明度，默认已做优化 */
public var automaticallyChangeAlpha: Bool = false
    
/** 回显时的渐显时间 0.1 ～ 2秒 默认0.5 */
public var fadeinTime: CGFloat = 0.5
    
/** 回显时的渐隐时间 0.1 ～ 5秒 默认1.5 */
public var fadeoutTime: CGFloat = 1.5
    
/** 提示文字字体大小 9 ～ 20 默认11 */
public var tipLabelFontSize: CGFloat = 11
    
/** 结果文字字体大小 9 ～ 20 默认12 */
public var resultLabelFontSize: CGFloat = 12

```
#### 使用链式编程配置时，请在所有属性前加tg_前缀即可

### 更多使用配置组合效果请下载本项目或fork本项目查看

## Installation
- 下载并拖动TGRefreshSwift到你的工程中

- Cocoapods
```
pod 'TGRefreshSwift'
```

## Reference
- http://blog.csdn.net/callzjy
- https://github.com/targetcloud/baisibudejie



如果你觉得赞，请Star

<img src="https://github.com/targetcloud/TGRefreshSwift/blob/master/logo.png" width = "20%" hight = "20%"/>


