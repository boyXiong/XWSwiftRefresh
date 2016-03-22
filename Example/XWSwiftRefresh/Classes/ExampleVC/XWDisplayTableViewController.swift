//
//  XWDisplayTableViewController.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/7.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

class XWDisplayTableViewController: UITableViewController {
    
//    var model:exampleModel = exampleModel
    
    var data:Array<String> = ["数据-1", "数据-2", "数据-3"]
    
    
    var method:String = "" {
        
        didSet{
            self.xwExeAction(Selector(method))
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

    }
    
    //默认模式
    func example001(){
        
        
        
        
       /* 过期方法
        //添加上拉刷新
        self.tableView.addHeaderWithCallback {
            [weak self] () -> () in
            if let selfStrong = self {
                selfStrong.upPullLoadData()
                selfStrong.tableView.endHeaderRefreshing()
            }
        }
        
        //添加下拉刷新
        self.tableView.addFooterWithCallback {
            [weak self] () -> () in
            if let selfStrong = self {
                selfStrong.downPlullLoadData()
                selfStrong.tableView.endFooterRefreshing()
            }
        }
        */
        
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        
        self.tableView.headerView?.beginRefreshing()
        self.tableView.headerView?.endRefreshing()
        
        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        
        
    }
    
    //gif图片模式
    func example011(){
        
        
        var idleImages = [UIImage]()
        for (var i = 1; i<=20; i++) {
            let image = UIImage(named: String(format: "mono-black-%zd", i))
            idleImages.append(image!)
        }
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshingImages = [UIImage]()
        for (var i = 1; i<=20; i++) {
            let image = UIImage(named: String(format: "mono-black-%zd", i))
            refreshingImages.append(image!)
        }
        
        // 其实headerView是一个View 拿出来，更合理
        let headerView = XWRefreshGifHeader(target: self, action: "upPullLoadData")
        
        //这里是 XWRefreshGifHeader 类型,就是gif图片
        headerView.setImages(idleImages, duration: 0.8, state: XWRefreshState.Idle)
        headerView.setImages(refreshingImages, duration: 0.8, state: XWRefreshState.Refreshing)
        
        
        
        //隐藏状态栏
        headerView.refreshingTitleHidden = true
        //隐藏时间状态
        headerView.refreshingTimeHidden = true
        //根据上拉比例设置透明度
        headerView.automaticallyChangeAlpha = true
        
        self.tableView.headerView = headerView
                        
    }
    
    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            
            for var i = 0 ;  i < 15 ; ++i {
                self.data.append("数据-\(i + self.data.count)")
            }
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            for var i = 0 ;  i < 15 ; ++i {
                self.data.append("数据-\(i + self.data.count)")
            }
            self.tableView.reloadData()
            self.tableView.footerView?.endRefreshing()
        }
      
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
                
        return cell
    }
}
