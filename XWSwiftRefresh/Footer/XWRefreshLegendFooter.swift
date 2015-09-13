//
//  XWRefreshLegendFooter.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/12.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit

class XWRefreshLegendFooter: XWRefreshFooter {
    
    
    //菊花
    lazy var activityView:UIActivityIndicatorView = {
        
        [unowned self] in
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.addSubview(activityView)
        
        return activityView
        }()
    
    //在layoutSubviews中最好只拿到 控件的宽高
    override func layoutSubviews() {
        
        super.layoutSubviews()
        //指示器
        
        if self.stateHidden {
            self.activityView.center = CGPointMake(self.xw_width * 0.5, self.xw_height * 0.5 )
        }else {
            self.activityView.center = CGPointMake(self.xw_width * 0.5 - 100, xw_height * 0.5)
        }
    }
    
    //从写观察者属性
    override var state:XWRefreshFooterState {
        willSet{
            if state == newValue {return}
                self.switchStateDoSomething(newValue)
        }
    }
    private func switchStateDoSomething(state:XWRefreshFooterState){
        
        //4.判断当前的状态
        switch state {
            
            //4.1如果是刷新状态
        case .Idle :
            self.activityView.stopAnimating()
        case .Refreshing:
            self.activityView.startAnimating()
        case .NoMoreData:
            self.activityView.stopAnimating()
            
        }
    }
}
