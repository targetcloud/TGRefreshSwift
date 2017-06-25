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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
        tv.delegate = self
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        builderOrdinary()
    }

    @objc fileprivate func loadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            let isSuccess = arc4random_uniform(3) % 2 == 0
            let count = isSuccess ? arc4random_uniform(20) : 0
            self.dataCount = count>0 ? Int(count) : self.dataCount
            self.refreshCtl?.refreshResultStr = count>0 ? "成功刷新到\(count)条数据" : "没有更新数据"
            self.refreshCtl?.isSuccess = isSuccess
            isSuccess ? self.tv.reloadData() : ()
            self.refreshCtl?.endRefreshing()
        }
    }
    
    @objc fileprivate func loadDataSenior(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.tv.tg_header?.refreshResultStr = "成功刷新到10条数据"
            self.tv.tg_header?.endRefreshing()
        }
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
        refreshCtl?.isShowSuccesOrFailInfo = false
        refreshCtl?.refreshSuccessStr = ""
        refreshCtl?.automaticallyChangeAlpha = true
        refreshCtl?.verticalAlignment = .Midden
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
}

