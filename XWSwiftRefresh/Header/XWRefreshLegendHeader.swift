//
//  XWRefreshLegendHeader.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/10.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit

class XWRefreshLegendHeader: XWRefreshHeader {
    
    //图片
    lazy  var arrowImage:UIImageView = {
        [unowned self] in
        var path:NSString = "xw_icon.bundle"
        path = path.stringByAppendingPathComponent("xw_down.png")
        let imageView = UIImageView(image: UIImage(named: String(path)))
        
        self.addSubview(imageView)
        
        return imageView
    }()
    
    //菊花
    lazy var activityView:UIActivityIndicatorView = {
        
        [unowned self] in
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.bounds = self.arrowImage.bounds
        
        self.addSubview(activityView)
        
        return activityView
    }()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        //箭头 
        var arrowX = self.xw_width * 0.5
        if !self.updatedTimeHidden{
            arrowX = self.xw_width * 0.1
        
        }
        //箭头
        self.arrowImage.center = CGPointMake(arrowX, self.xw_height * 0.5)
        //指示器
        self.activityView.center = self.arrowImage.center
    }

    /** 辅助记录 旧值 */
    private var oldState:XWRefreshHeaderState!
    //从写观察者属性
    override var state:XWRefreshHeaderState?{
        
        willSet{
            self.oldState = state
            if state == newValue {return}
            if let realValue = newValue{
                 self.switchStateDoSomething(realValue)
            }
        }
        
    }
    private func switchStateDoSomething(state:XWRefreshHeaderState){
        
        //4.判断当前的状态
        switch state {
            
            //4.1如果是刷新状态
        case .Idle :
            
            //4.1.1 旧值等于 真正刷新的状态
            if self.oldState == XWRefreshHeaderState.Refreshing {
                
                self.arrowImage.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.activityView.alpha = 0.0
                    self.arrowImage.alpha = 1.0
                    }, completion: { (flag) -> Void in
                        self.activityView.alpha = 1.0
                        self.activityView.stopAnimating()
                        
                })
                
                //4.1.2 不然就反正之前的
                
            }else{
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.arrowImage.transform = CGAffineTransformIdentity
                    
                })
            }
            //如果在下拉
        case .Pulling:
            UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                let tmp:CGFloat = 0.000001 - CGFloat(M_PI)
                self.arrowImage.transform = CGAffineTransformMakeRotation(tmp);
            })
            
        case .Refreshing:
            self.arrowImage.alpha = 0.0
            self.activityView.startAnimating()
            
        }
        
    }
}
        