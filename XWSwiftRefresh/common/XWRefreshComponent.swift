//
//  XWRefreshComponent.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit




 class XWRefreshComponent: UIView {

    //MARK 给外界访问的
    
    //1.字体颜色
    var textColor:UIColor?
    
    //2.字体大小
    var font:UIFont?
    
    //3.刷新的target
    weak var refreshingTarget:AnyObject!
    
    //4.执行的方法
    var refreshingAction:Selector!
    
    //5.真正刷新 回调
    var refreshingBlock = {}
    
    //MARK 方法
    
    /* 1. 设置 回调方法 */
    func setRefreshingTarget(target:AnyObject, action:Selector){
        self.refreshingTarget = target
        self.refreshingAction = action
        
    }
    
    //MARK 公共接口
    
    /** 2. 进入刷新状态 */
    func beginRefreshing(){}
    /** 3. 结束刷新状态 */
    func endRefreshing(){}
    /** 4. 是否正在刷新 */
    func isRefreshing(){}

    //MARK 私有的
    
    /** 记录scrollView刚开始的inset */
    var scrollViewOriginalInset:UIEdgeInsets?
    /** 父控件 */
    weak var scrollView:UIScrollView!
    
    
    //从写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 基本属性 只适应 高度
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        
        // 默认文字颜色和字体大小
        self.textColor = XWRefreshLabelTextColor
        self.font = XWRefreshLabelFont
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //重写父类方法 这个view 会添加到 ScrollView 上去
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        //1.旧的父控件 移除监听
        self.superview?.removeObserver(self, forKeyPath: XWRefreshContentOffset, context: nil)
        
        //2.添加监听
        if let tmpNewSuperview = newSuperview  {
            tmpNewSuperview .addObserver(self, forKeyPath: XWRefreshContentOffset, options: NSKeyValueObservingOptions.New, context: nil)
            
            //2.1设置宽度
            self.xw_width = tmpNewSuperview.xw_width
            
            //2.2 设置位置
            self.xw_x = 0
    
            
            //2.3记录UIScrollView
            self.scrollView = tmpNewSuperview as! UIScrollView
       
            
            //2.4 设置用于支持 垂直下拉有弹簧的效果
            self.scrollView.alwaysBounceVertical = true;
            
            //2.5 记录UIScrollView最开始的contentInset
            self.scrollViewOriginalInset = self.scrollView.contentInset;
            
        }

    }
}