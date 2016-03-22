//
//  XWRefreshHeader.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

/** 抽象类不直接使用 用于重写*/
public class XWRefreshHeader: XWRefreshComponent {
    
    //MARK: 公开的
    
    /** 利用这个key来保存上次的刷新时间（不同界面的刷新控件应该用不同的dateKey，以区分不同界面的刷新时间） */
    var lastUpdatedateKey:String = ""
    
    /** 忽略多少scrollView的contentInset的top */
    public var ignoredScrollViewContentInsetTop:CGFloat = 0.0
    
    /** 上一次下拉刷新成功的时间 */
    public var lastUpdatedTime:NSDate{
        get{
            if let realTmp =  NSUserDefaults.standardUserDefaults().objectForKey(self.lastUpdatedateKey){
                
                return realTmp as! NSDate
                
            }else{
                return NSDate()
            }
        }
    }
    
       
    //MARK: 覆盖父类方法
    override func prepare() {
        super.prepare()
        
        // 设置key
        self.lastUpdatedateKey = XWRefreshHeaderLastUpdatedTimeKey
        
        // 设置高度
        self.xw_height = XWRefreshHeaderHeight
        
    }
    
    override func placeSubvies() {
        super.placeSubvies()
        
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        self.xw_y = -self.xw_height - self.ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(change: Dictionary<String,AnyObject>?) {
        super.scrollViewContentOffsetDidChange(change)
        
        // 在刷新的refreshing状态
        if self.state == XWRefreshState.Refreshing { return }
        
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = self.scrollView.contentInset
        
        
        // 当前的contentOffset
        let offsetY = self.scrollView.xw_offSetY
        
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if offsetY > happenOffsetY { return }
        
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - self.xw_height
        let pullingPercent = (happenOffsetY - offsetY) / self.xw_height
        
        // 如果正在 拖拽
        if self.scrollView.dragging {
            self.pullingPercent = pullingPercent
            
            
            if self.state == XWRefreshState.Idle && offsetY < normal2pullingOffsetY {
                // 转为即将刷新状态
                self.state = XWRefreshState.Pulling
                
            } else if self.state == XWRefreshState.Pulling && offsetY >= normal2pullingOffsetY {
                
                // 转为普通状态
                self.state = XWRefreshState.Idle
            }
            
        } else if self.state == XWRefreshState.Pulling {
            //开始刷新
            self.beginRefreshing()
            
        } else if self.pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
        
        
    }
    
    
    
    
    //MARK: 改变状态后
    /** 刷新控件的状态 */
    override var state:XWRefreshState{
        
        didSet{
            
            //状态和以前的一样就不用改变
            if oldValue == state {
                return
            }
            
            //根据状态来做一些事情
            if state == XWRefreshState.Idle {
                if oldValue != XWRefreshState.Refreshing { return }
                
                //保存刷新的时间
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: self.lastUpdatedateKey as String)
                
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // 恢复inset和offset
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { [unowned self] () -> Void in
                    self.scrollView.xw_insertTop -= self.xw_height
                    
                    // 自动调整透明度
                    if self.automaticallyChangeAlpha {self.alpha = 0.0}

                    }, completion: { [unowned self] (flag) -> Void in
                        
                        self.pullingPercent = 0.0
                })
    
            }else if state == XWRefreshState.Refreshing {
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: {[unowned self] () -> Void in
                    
                    let top = self.scrollViewOriginalInset.top + self.xw_height
                    
                    // 增加滚动区域
                    self.scrollView.xw_insertTop = top
                    
                    // 设置滚动位置
                    self.scrollView.xw_offSetY = -top
                    
                    
                    }, completion: { (flag) -> Void in
                        self.executeRefreshingCallback()
                })
                
            }
        }
    }
    
    /** 结束刷新 */
    override public func endRefreshing() {
        
        if self.scrollView.isKindOfClass(UICollectionView){
            
            xwDelay(0.1){
                super.endRefreshing()
            }
        }else{
            
            super.endRefreshing()
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





