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
    var refreshCtl:TGRefreshSwift?
    
    fileprivate let identifier = "cell"
    fileprivate var dataCount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
        tv.delegate = self
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        refreshCtl = TGRefreshSwift()
        refreshCtl?.ignoreScrollViewContentInsetTop = true
        refreshCtl?.refreshResultBgColor = UIColor.orange.withAlphaComponent(0.8)
//        refreshCtl?.kind = .Common
        refreshCtl?.tinColor = UIColor.red
        refreshCtl?.isShowSuccesOrFailInfo = false
        refreshCtl?.refreshSuccessStr = ""
        refreshCtl?.automaticallyChangeAlpha = true
        refreshCtl?.verticalAlignment = .Top
        tv.addSubview(refreshCtl!)
        refreshCtl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshCtl?.beginRefreshing()
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

