//
//  XWRefreshFooter.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/11.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

/** 抽象类，不直接使用，用于继承后，重写*/
public class XWRefreshFooter: XWRefreshComponent {
    
    //MARK: 提供外界访问的
    /** 提示没有更多的数据 */
    public func noticeNoMoreData(){ self.state = XWRefreshState.NoMoreData }
    
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    public func resetNoMoreData(){  self.state = XWRefreshState.Idle }
    
    /** 忽略多少scrollView的contentInset的bottom */
    public var ignoredScrollViewContentInsetBottom:CGFloat = 0
    
    /** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏） */
    public var automaticallyHidden:Bool = true
    
    
    //MARK: 私有的
    
    //重写父类方法
    override func prepare() {
        super.prepare()
        self.xw_height = XWRefreshFooterHeight
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let _ = newSuperview {
            
            //监听scrollView数据的变化
            //由于闭包是Any 所以不能采用关联对象
            let tmpClass = xwReloadDataClosureInClass()
            tmpClass.reloadDataClosure = { (totalCount:Int) -> Void in
                
                if self.automaticallyHidden == true {
                    //如果开启了自动隐藏，那就是在检查到总数量为 请求后的加载0 的时候就隐藏
                    self.hidden = totalCount == 0
                }
            }
            self.scrollView.reloadDataClosureClass = tmpClass

        }
    }
}



