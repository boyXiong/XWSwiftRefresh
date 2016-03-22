//
//  XWConst.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪



import UIKit


//文字颜色
let XWRefreshLabelTextColor = xwColor(r: 100, g: 100, b: 100)
//字体大小
let XWRefreshLabelFont = UIFont.boldSystemFontOfSize(13)



/** 头部高度 */
let XWRefreshHeaderHeight:CGFloat = 64
/** 尾部高度 */
let XWRefreshFooterHeight:CGFloat = 44

/** gifView 偏差 */
let XWRefreshGifViewWidthDeviation:CGFloat = 99

/** footer 菊花 偏差 */
let XWRefreshFooterActivityViewDeviation:CGFloat = 100

/** 开始的动画时间 */
let XWRefreshFastAnimationDuration = 0.25
/** 慢的动画时间 */
let XWRefreshSlowAnimationDuration = 0.4

/** 更新的时间 */
let XWRefreshHeaderLastUpdatedTimeKey = "XWRefreshHeaderLastUpdatedTimeKey"
/** 也就是上拉下拉的多少*/
let XWRefreshKeyPathContentOffset = "contentOffset"
/** 内容的size */
let XWRefreshKeyPathContentSize = "contentSize"
/** 内边距 */
let XWRefreshKeyPathContentInset = "contentInset"
/** 手势状态 */
let XWRefreshKeyPathPanKeyPathState = "state"

let XWRefreshHeaderStateIdleText = "下拉可以刷新"
let XWRefreshHeaderStatePullingText = "松开立即刷新"
let XWRefreshHeaderStateRefreshingText = "正在刷新数据中..."


let XWRefreshFooterStateIdleText = "点击加载更多"
let XWRefreshFooterStateRefreshingText = "正在加载更多的数据..."
let XWRefreshFooterStateNoMoreDataText = "已经全部加载完毕"

/** 图片路径 */
let XWIconSrcPath:String = "Frameworks/XWSwiftRefresh.framework/xw_icon.bundle/xw_down.png"

let XWIconLocalPath:String = "xw_icon.bundle/xw_down.png"


