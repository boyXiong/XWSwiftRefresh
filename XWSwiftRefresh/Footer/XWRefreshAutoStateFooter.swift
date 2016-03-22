//
//  XWRefreshAutoStateFooter.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/6.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

/** footerView 只有状态文字 */
public class XWRefreshAutoStateFooter: XWRefreshAutoFooter {
    
    //MARK: 外部

    /** 显示刷新状态的label */
    lazy var stateLabel:UILabel = {
       [unowned self] in
        let lable = UILabel().Lable()
        self.addSubview(lable)
        return lable
    }()
    
    /** 隐藏刷新状态的文字 */
    public var refreshingTitleHidden:Bool = false
    
    /** 设置状态的显示文字 */
    public func setTitle(title:String, state:XWRefreshState){
        self.stateLabel.text = self.stateTitles[self.state];
    }

    
    //MARK: 私有的
    /** 每个状态对应的文字 */
    private var stateTitles:Dictionary<XWRefreshState, String> = [
        XWRefreshState.Idle : XWRefreshFooterStateIdleText,
        XWRefreshState.Refreshing : XWRefreshFooterStateRefreshingText,
        XWRefreshState.NoMoreData : XWRefreshFooterStateNoMoreDataText
    ]
    
    override func prepare() {
        super.prepare()
        
        self.stateLabel.userInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "stateLabelClick"))
        self.stateLabel.text = self.stateTitles[state]

    }
    
    func stateLabelClick(){
        if self.state == XWRefreshState.Idle {
            self.beginRefreshing()
        }
    }
    
    override func placeSubvies() {
        super.placeSubvies()
        self.stateLabel.frame = self.bounds
    }
    
    
    override var state:XWRefreshState {
        didSet{
            if oldValue == state { return }
                
            if self.refreshingTitleHidden && state == XWRefreshState.Refreshing {
                self.stateLabel.text = nil
            }else {
                self.stateLabel.text = self.stateTitles[state]
            }
        }
    }
}
