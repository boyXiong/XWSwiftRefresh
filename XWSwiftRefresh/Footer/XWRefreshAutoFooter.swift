//
//  XWRefreshAutoFooter.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/6.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit


/** footerView 什么样式都没有的 */
public class XWRefreshAutoFooter: XWRefreshFooter {
    
    //MARK: 公共接口
    /** 是否自动刷新(默认为YES) */
    public var automaticallyRefresh:Bool = true
    
    /** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
//    @available(*, deprecated=1.0, message="Use -automaticallyChangeAlpha instead.")
    var appearencePercentTriggerAutoRefresh:CGFloat = 1.0 {
        willSet{
            self.triggerAutomaticallyRefreshPercent = newValue
        }
    }
    
    /** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
    public var triggerAutomaticallyRefreshPercent:CGFloat = 1.0
    
    
    //MARK: 重写
    
    //初始化
    override public func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        if let _ = newSuperview {
            if self.hidden == false {
                self.scrollView.xw_insertBottom += self.xw_height
            }
            //设置位置
            self.xw_y = self.scrollView.xw_contentH
            
        }else { // 被移除了两种结果，一种是手动移除，一种是父控件消除
            //TODO:防止 是 空的
            if let realScrollView = self.scrollView {
                if self.hidden == false {
                    realScrollView.xw_insertBottom -= self.xw_height
                }
            }
            
        }
    }
    
    //MARK: 实现父类的接口
    override func scrollViewContentSizeDidChange(change: Dictionary<String, AnyObject>?) {
        super.scrollViewContentSizeDidChange(change)
        
        //设置位置
        self.xw_y = self.scrollView.xw_contentH
    }
    
    override func scrollViewContentOffsetDidChange(change: Dictionary<String, AnyObject>?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if self.state != XWRefreshState.Idle || !self.automaticallyRefresh || self.xw_y == 0 { return }
        
        if self.scrollView.xw_insertTop + self.scrollView.xw_contentH > self.scrollView.xw_height {
            // 内容超过一个屏幕
            //TODO: 计算公式，判断是不是在拖在到了底部
            if self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.bottom + self.xw_height * self.triggerAutomaticallyRefreshPercent - self.xw_height <= self.scrollView.xw_height {
                
                self.beginRefreshing()
                
            }
        }
    }
    
    override func scrollViewPanStateDidChange(change: Dictionary<String, AnyObject>?) {
        super.scrollViewPanStateDidChange(change)
        
        
        if self.state != XWRefreshState.Idle { return }
        
        //2.1.1 抬起
        if self.scrollView.panGestureRecognizer.state == UIGestureRecognizerState.Ended {

            // 向上拖拽
            func draggingUp(){
                //如果是向 上拖拽 刷新
                if self.scrollView.contentOffset.y > -self.scrollView.contentInset.top {
                    beginRefreshing()
                }
            }

            //2.2.1.1 不够一个屏幕的滚动 top + content.height 就是内容显示的高度
            if self.scrollView.contentInset.top +
                self.scrollView.contentSize.height < self.scrollView.xw_height {
                    draggingUp()
            //2.1.1.2 超出一个屏幕 也就是scrollView的
            }else {
                //拖拽到了底部
                if self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom  == self.scrollView.xw_height {
                    draggingUp()
                }
                
            }
        }

    }
    
    override var state:XWRefreshState {
        didSet{
            if state == oldValue { return }
            if state == XWRefreshState.Refreshing {
                xwDelay(0.5, task: { () -> Void in
                    self.executeRefreshingCallback()
                })
            }
        }
    }
    
    
    override public var hidden:Bool{
        didSet{
            //如果之前没有隐藏的现在隐藏了，那么要设置状态和去掉底部区域
            if !oldValue && hidden {
                self.state = XWRefreshState.Idle
                self.scrollView.xw_insertBottom -= self.xw_height
                
            //如果之前是隐藏的，现在没有隐藏了，那么要增加底部区域
            }else if oldValue && !hidden {
                self.scrollView.xw_insertBottom += self.xw_height
                
                // 设置位置
                self.xw_y = self.scrollView.xw_contentH
            }
            
        }
    }
    
    
    
}
