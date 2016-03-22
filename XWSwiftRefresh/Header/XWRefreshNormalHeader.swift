//
//  XWRefreshNormalHeader.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/5.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

/** headerView 带有状态和指示图片*/
public class XWRefreshNormalHeader: XWRefreshStateHeader {
    
    //MARK: 外界接口
    
    /** 菊花样式 */
    public var activityIndicatorViewStyle:UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray {
        
        didSet{
            self.activityView.activityIndicatorViewStyle = activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    /** 指示器的图片[箭头] */
    public var arrowImage:UIImage? {
        didSet{
            
            self.arrowView.image = arrowImage
            self.placeSubvies()
        }
    }
    
    
    //MARK: lazy
    //图片
    /** 指示图片 */
    lazy  var arrowView:UIImageView = {
        [unowned self] in

        var image = UIImage(named:XWIconSrcPath)
        if image == nil {
            image = UIImage(named: XWIconLocalPath)
        }
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    
    
    //菊花
    private lazy var activityView:UIActivityIndicatorView = {
        
        [unowned self] in
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        activityView.bounds = self.arrowView.bounds
        
        self.addSubview(activityView)
        
        return activityView
        }()

    
    //MARK: 重写父类方法
    override func placeSubvies() {
        super.placeSubvies()
        //箭头
        self.arrowView.xw_size = (self.arrowView.image?.size)!
        var arrowCenterX = self.xw_width * 0.5
        if !self.stateLabel.hidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.xw_height * 0.5
        self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY)
        
        //菊花
        self.activityView.frame = self.arrowView.frame
    }
    
    //从写观察者属性
    /** 辅助记录 旧值 */
    private var oldState:XWRefreshState!
    override var state:XWRefreshState{
        
        didSet{
            self.oldState = oldValue
            if state == oldValue {return}
            self.switchStateDoSomething(state)
        }
    }
    
    private func switchStateDoSomething(state:XWRefreshState){
        
        func commonFun(){
            self.activityView.stopAnimating()
            self.arrowView.hidden = false
        }

        
        //4.判断当前的状态
        switch state {
            
            //4.1如果是刷新状态
        case .Idle :
            
            //4.1.1 旧值等于 真正刷新的状态
            if self.oldState == XWRefreshState.Refreshing {
                self.arrowView.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.activityView.alpha = 0.0
                    }, completion: { (flag) -> Void in
                        
                        // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                        if self.state != XWRefreshState.Idle { return }
                        
                        self.activityView.alpha = 1.0
                        commonFun()
                                                
                })
                
                //4.1.2 不然就反正之前的
            }else{
                commonFun()
                UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.arrowView.transform = CGAffineTransformIdentity
                    
                })
            }
            //如果在下拉
        case .Pulling:
            commonFun()
            UIView.animateWithDuration(XWRefreshSlowAnimationDuration, animations: { () -> Void in
                let tmp:CGFloat = 0.000001 - CGFloat(M_PI)
                self.arrowView.transform = CGAffineTransformMakeRotation(tmp);
            })
            
        case .Refreshing:
            self.arrowView.hidden = true
            self.activityView.alpha = 1.0 // 防止refreshing -> idle的动画完毕动作没有被执行
            self.activityView.startAnimating()
        default: break
            
        }
        
        
    }
}
    
