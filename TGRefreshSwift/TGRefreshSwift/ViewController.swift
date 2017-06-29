//
//  ViewController.swift
//  TGRefreshSwift
//
//  Created by targetcloud on 2017/6/24.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tv: UITableView!
    var refreshCtl:TGRefreshSwift?//高级用法时这行可以去掉
    
    fileprivate let identifier = "cell"
    fileprivate var dataCount: Int = 10
    fileprivate var isPullUp = false
    lazy var footIndicatorView: TGIndicatorView = {
        let indicator = TGIndicatorView(frame:CGRect(x: 0, y: 0, width: 20, height: 20),
                                        type:.lineScalePulseOut,
                                        color:UIColor.orange)
        indicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
        tv.delegate = self
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        tv.tableFooterView = footIndicatorView
        
        
        //一般用法
        //builderOrdinary()
        
        //简单用法
        //builderSimple()
        
        //高级用法
        //buildSenior()
        
        //最优推荐用法
        builderRecommend4()
    }

    @objc fileprivate func loadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let isSuccess = arc4random_uniform(3) % 2 == 0
            let count = isSuccess ? arc4random_uniform(10)+1 : 0
            self.dataCount = count>0 ? Int(count) : self.dataCount
            self.refreshCtl?.refreshResultStr = count>0 ? "成功刷新到\(count)条数据" : "没有更新数据"
            self.refreshCtl?.isSuccess = isSuccess
            isSuccess ? self.tv.reloadData() : ()
            self.refreshCtl?.endRefreshing()
        }
    }
    
    @objc fileprivate func loadDataSenior(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let isSuccess = arc4random_uniform(3) % 2 == 0
            let count = isSuccess ? arc4random_uniform(10)+1 : 0
            self.isPullUp ? (self.dataCount += count>0 ? Int(count) : self.dataCount) : (self.dataCount = count>0 ? Int(count) : self.dataCount)
            !self.isPullUp ? self.tv.tg_header?.refreshResultStr = count>0 ? "成功刷新到\(count)条数据,来自TGRefreshSwift" : "请先在Github上Star本控件:-）" : ()
            !self.isPullUp ? self.tv.tg_header?.isSuccess = isSuccess : ()
            isSuccess ? self.tv.reloadData() : ()
            !self.isPullUp ? self.tv.tg_header?.endRefreshing() : ()
            self.isPullUp ? self.footIndicatorView.stopAnimating() : ()
            self.isPullUp = false//恢复标记
        }
    }
}

extension ViewController{
    //QQ效果
    fileprivate func builderRecommend(){
        self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior))
        self.tv.tg_header?.beginRefreshing()
    }
    
    //QQ效果
    fileprivate func builderRecommend2(){
        self.tv.tg_header = TGRefreshSwift.refresh()
        self.tv.tg_header?.addTarget(self, action: #selector(loadDataSenior), for: .valueChanged)
        self.tv.tg_header?.beginRefreshing()
    }
    
    //一般平常效果
    fileprivate func builderRecommend3(){
        self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior)){(refresh) in
            refresh.tg_kind(.Common)
        }
        self.tv.tg_header?.beginRefreshing()
    }
    
    //更多配置
    fileprivate func builderRecommend4(){
        self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior)){(refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_kind(.Common)
                .tg_tinColor(UIColor.orange)
                .tg_fadeinTime(1)
                .tg_fadeoutTime(0.5)
                .tg_verticalAlignment(.Midden)
                .tg_indicatorRefreshingStyle(.lineCursor)
                .tg_indicatorNormalStyle(.lineOrderbyAsc)
                .tg_bgColor(UIColor(white:0.8,alpha:1))
        }
        self.tv.tg_header?.beginRefreshing()
    }
    
    //扩展用法
    fileprivate func builderRecommend5(){
        self.tv.tg_header = TGRefreshSwift.refresh(self, #selector(loadDataSenior),44,UIImageView(image: UIImage(named: "profile_cover_background")) ){(refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_verticalAlignment(.Midden)
                .tg_tinColor(UIColor.white)
                .tg_tipLabelFontSize(12)
                .tg_resultLabelFontSize(13)
                .tg_tipFailStyle(.ballScale)
                .tg_tipOKStyle(.ballScale)
                .tg_indicatorRefreshingStyle(.orbit)
                .tg_fadeinTime(1)
                .tg_fadeoutTime(0.5)
                .tg_bgColor(UIColor(white:0.5,alpha:1))
        }
        self.tv.tg_header?.beginRefreshing()
    }
}

extension ViewController{
    fileprivate func buildSenior(){
        self.tv.tg_header = TGRefreshSwift(self, #selector(loadDataSenior)) { (refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_bgColor(UIColor(white:0.8,alpha:1))
                .tg_refreshResultTextColor(UIColor.white)
        }
        self.tv.tg_header?.beginRefreshing()
    }
}

extension ViewController{
    fileprivate func builderSimple(){
        self.refreshCtl = TGRefreshSwift(self, #selector(loadData)) { (refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_bgColor(UIColor(white:0.8,alpha:1))
                .tg_refreshResultTextColor(UIColor.white)
        }
        tv.addSubview(refreshCtl!)
        self.refreshCtl?.beginRefreshing()
    }
    
    fileprivate func builderSimple2(){
        self.refreshCtl = TGRefreshSwift{ (refresh) in
            refresh.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
                .tg_bgColor(UIColor(white:0.8,alpha:1))
                .tg_refreshResultTextColor(UIColor.white)
        }
        tv.addSubview(refreshCtl!)
        refreshCtl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshCtl?.beginRefreshing()
    }
}


extension ViewController{
    fileprivate func builderOrdinary(){
        //******************有contentInset测试****************
        //可以去掉这段
        let label:UILabel  = UILabel()
        label.backgroundColor = UIColor.lightGray
        label.frame = CGRect(x:0, y:-80, width:UIScreen.main.bounds.width, height:80)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.text = "TGRefreshSwift下拉刷新控件是一款TGRefreshOC增强控件，同时支持QQ样式（橡皮筋）和普通样式的下拉刷新控件。支持链式配置,配置参数更多更灵活。"
        label.textAlignment = .center
        self.tv.addSubview(label)
        self.tv.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        //***************************************************
        
        refreshCtl = TGRefreshSwift()
        //配置根据需要写，也可以不写任何配置
        //*****************普通配置***************************
        //与下面链式配置二选一，也可以一起写
        //refreshCtl?.ignoreScrollViewContentInsetTop = true
        refreshCtl?.refreshResultBgColor = UIColor.orange.withAlphaComponent(0.8)
//        refreshCtl?.kind = .Common//QQ效果不写此行
        refreshCtl?.tinColor = UIColor.orange
//        refreshCtl?.isShowSuccesOrFailInfo = false
        refreshCtl?.refreshSuccessStr = ""
        refreshCtl?.automaticallyChangeAlpha = true
        refreshCtl?.verticalAlignment = .Top
        refreshCtl?.bgColor =  UIColor(white: 0.8, alpha: 1)
        //***************************************************
        
        //*****************链式配置***************************
        //与上面普通配置二选一，也可以一起写
        refreshCtl?.tg_refreshResultBgColor(UIColor.orange.withAlphaComponent(0.8))
            .tg_refreshResultTextColor(UIColor.white)
            .tg_refreshResultHeight(38)
            .tg_refreshNormalStr("pull down refresh")
            .tg_refreshPullingStr("let go")
            .tg_refreshingStr("refreshing...")
            .tg_refreshSuccessStr("success")
            .tg_refreshFailStr("fail")
        //***************************************************
        
        tv.addSubview(refreshCtl!)
        refreshCtl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshCtl?.beginRefreshing()//一进入界面就需要刷新写这一行
    }
    
    fileprivate func builderOrdinary2(){
        refreshCtl = TGRefreshSwift(frame: CGRect(x: 0, y: 0, width: 0, height: 50))//带高度，默认40
        refreshCtl?.bgColor =  UIColor(white: 0.8, alpha: 1)
        refreshCtl?.kind = .Common//QQ效果不写此行
        tv.addSubview(refreshCtl!)
        refreshCtl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshCtl?.beginRefreshing()//一进入界面就需要刷新写这一行
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = "第\(indexPath.row)行测试数据"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 &&
            scrollView.contentSize.height - self.tv.frame.size.height - scrollView.contentOffset.y <= 0 &&
            !isPullUp &&
            !footIndicatorView.isAnimating{
            footIndicatorView.type = TGIndicatorType(rawValue: Int(arc4random_uniform(UInt32(TGIndicatorType.allTypes.count - 1))) + 1)!
            footIndicatorView.startAnimating()
            isPullUp = true
            loadDataSenior()
        }
    }
}
