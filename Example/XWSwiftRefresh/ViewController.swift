//
//  ViewController.swift
//  XWSwiftRefresh
//
//  Created by key on 15/9/13.
//  Copyright © 2015年 key. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var data:NSMutableArray = [1,2,3,4,5,6,7,8]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.alpha = 0.5
        self.title = "上拉和下拉刷新"
        
        self.tableView.tableFooterView = UIView()
        
        //使用方法,添加上拉刷新
        self.tableView.addHeaderWithCallback {
            [weak self] (Void) -> () in
            if let strongSelf = self {
                
                strongSelf.downUpLoadData()
            }
        }
        
        //添加下拉刷新
        self.tableView.addFooterWithCallback {
            [weak self] (Void) -> () in
            if let strongSelf = self {
                
                strongSelf.downLoadData()
                
            }
        }
        
        
    }
    
    func downLoadData(){
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            
            
            self.tableView.reloadData()
            
            self.tableView.endFooterRefreshing()
            
        }
        
    }
    
    func downUpLoadData(){
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            self.data.addObject(self.data.count)
            
            
            self.tableView.reloadData()
            
            self.tableView.endHeaderRefreshing()
            
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "T")
        cell.textLabel?.text = String(indexPath.row)
        cell.detailTextLabel?.text = "haha"
        
        return cell
    }
    


}

