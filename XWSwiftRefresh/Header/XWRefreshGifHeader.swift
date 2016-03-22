//
//  XWRefreshGifHeader.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/5.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit


/** headerView gif 样式 要设置gif状态图片*/
public class XWRefreshGifHeader: XWRefreshStateHeader {
    
    //MARK: 方法接口
    /** 设置刷新状态下,gif的图片 */
    public func setImages(images:Array<UIImage>, state:XWRefreshState) -> Self {
        
        return self.setImages(images, duration: NSTimeInterval(images.count) * 0.1, state: state)
    }
    /** 设置刷新状态下,gif的图片,动画每帧相隔的时间 */
    public func setImages(images:Array<UIImage>, duration:NSTimeInterval, state:XWRefreshState) -> Self {
        //防止空数组 []
        if images.count < 1 { return self}
        
        self.stateImages[state] = images;
        self.stateDurations[state] = duration;
        
        //根据图片设置控件的高度
        let image:UIImage = images.first!
        if image.size.height > self.xw_height {
            self.xw_height = image.size.height
        }
        
        return self
    }
    
    
    private lazy var gifView:UIImageView = {
        [unowned self] in
        let gifView = UIImageView()
        self.addSubview(gifView)
        return gifView
    }()
    
    private var stateImages:Dictionary<XWRefreshState, Array<UIImage>> = [XWRefreshState.Idle : []]
    private var stateDurations:Dictionary<XWRefreshState, NSTimeInterval> = [XWRefreshState.Idle : 1, XWRefreshState.Pulling : 1, XWRefreshState.Refreshing : 1]
    
    
    //MARK: 重写
    override public var pullingPercent:CGFloat {
        didSet{
            if  let images = self.stateImages[XWRefreshState.Idle] {
                
                if self.state != XWRefreshState.Idle || images.count < 1 { return }
                
                //停止动画
                self.gifView.stopAnimating()
                //设置当前需要显示的图片,根据百分比显示
                var index = Int(CGFloat(images.count) * pullingPercent)
                
                if index >= images.count { index = images.count - 1 }
                
                self.gifView.image = images[index]
            }
        }
    }
    
    override func placeSubvies() {
        super.placeSubvies()
        
        self.gifView.frame = self.bounds
        if self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden {
            self.gifView.contentMode = UIViewContentMode.Center
        }else {
            self.gifView.contentMode = UIViewContentMode.Right
            self.gifView.xw_width = self.xw_width * 0.5 - XWRefreshGifViewWidthDeviation
        }
    }
    
    override var state:XWRefreshState{
        didSet{
            if state == oldValue { return }
            self.switchStateDoSomething(state)
        }
    }
    
    private func switchStateDoSomething(state:XWRefreshState){

               
        if !(state == XWRefreshState.Pulling || state == XWRefreshState.Refreshing) { return }
        
        if let images = self.stateImages[state] {
            if images.count < 1 { return }
                
            self.gifView.stopAnimating()
            //单张图片
            if images.count == 1 {
                self.gifView.image = images.last
                    //多张图片
            } else {
                self.gifView.animationImages = images
                self.gifView.animationDuration = self.stateDurations[state]!
                self.gifView.startAnimating()
            }
        }
        
    }
    
    
}