//
//  XWConst.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit


//颜色
func xwColor(r r:Float, g:Float, b:Float) -> UIColor {
    
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
    
}

//文字颜色
let XWRefreshLabelTextColor = xwColor(r: 233, g: 233, b: 233)

//字体大小
let XWRefreshLabelFont = UIFont.boldSystemFontOfSize(13)



/** 头部高度 */
let XWRefreshHeaderHeight:CGFloat = 64.0
/** 尾部高度 */
let XWRefreshFooterHeight:CGFloat = 44.0
/** 开始的动画时间 */
let XWRefreshFastAnimationDuration = 0.25
/** 慢的动画时间 */
let XWRefreshSlowAnimationDuration = 0.4

/** 更新的时间 */
let XWRefreshHeaderUpdatedTimeKey = "XWRefreshHeaderUpdatedTimeKey"
/** 也就是上拉下拉的多少*/
let XWRefreshContentOffset = "contentOffset"
/** 内容的size */
let XWRefreshContentSize = "contentSize"

/** 手势状态 */
let XWRefreshPanState = "pan.state"

let XWRefreshHeaderStateIdleText = "下拉可以刷新"
let XWRefreshHeaderStatePullingText = "松开立即刷新"
let XWRefreshHeaderStateRefreshingText = "正在刷新数据中..."


let XWRefreshFooterStateIdleText = "点击加载更多"
let XWRefreshFooterStateRefreshingText = "正在加载更多的数据..."
let XWRefreshFooterStateNoMoreDataText = "已经全部加载完毕"


