//
//  XWRefreshStateHeader.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/4.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

/** headerView 只有状态文字 */
public class XWRefreshStateHeader: XWRefreshHeader {
    
    //MARK: 私有的
    /** 每个状态对应的文字 */
    private var stateTitles:Dictionary<XWRefreshState, String> = [
        XWRefreshState.Idle : XWRefreshHeaderStateIdleText,
        XWRefreshState.Refreshing : XWRefreshHeaderStateRefreshingText,
        XWRefreshState.Pulling : XWRefreshHeaderStatePullingText
    ]

    //MARK: 外界接口
    
    /** 利用这个colsure来决定显示的更新时间 */
    var closureCallLastUpdatedTimeTitle:((lastUpdatedTime:NSDate) -> String)?
    
    /** 显示上一次刷新时间的label */
    lazy var lastUpdatedTimeLabel:UILabel = {
        [unowned self] in
        let lable = UILabel().Lable()
        self.addSubview(lable)
        return lable
        }()
    
    
    /**  显示刷新状态的label */
    lazy var stateLabel:UILabel = {
        [unowned self] in
        let lable = UILabel().Lable()
        self.addSubview(lable)
        return lable
        }()
    
    
    /** 设置状态的显示文字 */
    public func setTitle(title:String, state:XWRefreshState){
        self.stateLabel.text = self.stateTitles[self.state];
    }
    
    /** 文字刷新状态下的显示与隐藏 */
    public var refreshingTitleHidden:Bool = false {
        didSet{
            if oldValue == refreshingTitleHidden { return }
            self.stateLabel.hidden = refreshingTitleHidden
        }
    }
    
    /** 时间刷新状态下的显示与隐藏*/
    public var refreshingTimeHidden:Bool = false {
        didSet{
            if oldValue == refreshingTimeHidden { return }
            self.lastUpdatedTimeLabel.hidden = refreshingTimeHidden

        }

    }

    
    //MARK: 重写
    
    override var lastUpdatedateKey:String{
        didSet{
            if let lastUpdatedTimeDate = NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedateKey) {
                
                let realLastUpdateTimeDate:NSDate = lastUpdatedTimeDate as! NSDate
                
                //如果有闭包
                if let internalClosure = self.closureCallLastUpdatedTimeTitle {
                    self.lastUpdatedTimeLabel.text = internalClosure(lastUpdatedTime:realLastUpdateTimeDate)
                    return
                }
                //得到精准的时间
                self.lastUpdatedTimeLabel.text = realLastUpdateTimeDate.xwConvertStringTime()
                
            }else{
                self.lastUpdatedTimeLabel.text = "最后更新:无记录"
                
            }
        }
    }
    
    override var state:XWRefreshState{
        didSet{
            if state == oldValue { return }
            self.stateLabel.text = self.stateTitles[self.state];
            
            self.lastUpdatedateKey = self.lastUpdatedateKey.self
            
        }
    }
    
    override func prepare() {
        super.prepare()
        //初始化文字
        self.setTitle(XWRefreshHeaderStateIdleText, state: .Idle)
        self.setTitle(XWRefreshHeaderStatePullingText, state: .Pulling)
        self.setTitle(XWRefreshHeaderStateRefreshingText, state: .Refreshing)

    }
    
    override func placeSubvies() {
        super.placeSubvies()
        //如果状态隐藏 就直接返回
        if self.stateLabel.hidden { return }
        
        if self.lastUpdatedTimeLabel.hidden {
            //状态
            self.stateLabel.frame = self.bounds
        }else {
            //状态
            self.stateLabel.frame = CGRectMake(0, 0, self.xw_width, self.xw_height * 0.5)
            
            //跟新的时间
            self.lastUpdatedTimeLabel.xw_x = 0
            self.lastUpdatedTimeLabel.xw_y = self.stateLabel.xw_height
            self.lastUpdatedTimeLabel.xw_width = self.xw_width
            self.lastUpdatedTimeLabel.xw_height = self.xw_height - self.lastUpdatedTimeLabel.xw_y
            
        }

    }

}
