//
//  UIScrollViewExtension-XW.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/9.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit


private var XWRefreshLegendHeaderKey:Void?
private var XWRefreshLegendFooterKey:Void?


extension UIScrollView {
    
    func addHeaderWithCallback(callBack:Void->()){
    
        self.headerView = XWRefreshLegendHeader()
        self.addSubview(self.headerView)
        self.headerView.refreshingBlock = callBack
        
    }
    
    
    private var headerView:XWRefreshLegendHeader {
        
        set{
            objc_setAssociatedObject(self, &XWRefreshLegendHeaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get{
           return objc_getAssociatedObject(self, &XWRefreshLegendHeaderKey) as! XWRefreshLegendHeader
        }
    }
    
    
    /*====================================================== */
    
    func addFooterWithCallback(callBack:Void->()){
        
        self.footerView = XWRefreshLegendFooter()
        self.addSubview(self.footerView)
        self.footerView.refreshingBlock = callBack
        
    }
    
    private var footerView:XWRefreshLegendFooter{
        set{
            objc_setAssociatedObject(self, &XWRefreshLegendFooterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get{
            
            return objc_getAssociatedObject(self, &XWRefreshLegendFooterKey) as! XWRefreshLegendFooter
        }
    }
    
    
    /** 开始刷新 */
    
    func beginHeaderRefreshing(){
        self.headerView.beginRefreshing()
    }
    /** 停止刷新 */
    
    func endHeaderRefreshing(){
        self.headerView.endRefreshing()
    }
    
    /** 开始刷新 */
    
    func beginFooterRefreshing(){
        self.footerView.beginRefreshing()
    }
    /** 停止刷新 */
    
    func endFooterRefreshing(){
        self.footerView.endRefreshing()
    }
    
}
