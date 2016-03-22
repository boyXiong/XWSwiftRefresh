//
//  XWShortcutMethod.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/1.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit
import Foundation

/**
根据RGB生成颜色UIColor

- parameter r: 红色
- parameter g: 绿色
- parameter b: 蓝色

- returns: UIColor对象
*/
func xwColor(r r:Float, g:Float, b:Float) -> UIColor {
    
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
    
}


public typealias xwTask = (cancel:Bool) -> ()

/** 延迟几秒后 在主线程中 执行闭包 ,返回xwTask 用于拿到后取消 */
public func xwDelay(time: NSTimeInterval, task:dispatch_block_t) -> xwTask? {
    
    func dispatch_later(closure:dispatch_block_t){
        
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                closure)
    }
    
    var closure:dispatch_block_t? = task
    
    var result:xwTask?
    
    let delayedClosure: xwTask = {
        cancel in
        if let realClosure = closure {
            
            if cancel == false {
                
                dispatch_async(dispatch_get_main_queue(), realClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later { () -> Void in
        if let delayedClosure = result {
            
            delayedClosure(cancel: false)
        }
    }
    
    return result
}

/** 取消 任务 */
public func xwCancel(task:xwTask?){
    
    task?(cancel:true)
}





/** ===========================================================================================
                                    NSObjectExtension
===============================================================================================*/

extension NSObject{
    //MARK: runtime
    class func exchangeInstanceMethod1(method1:Selector, method2:Selector){
        method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2))
    }
    
    class func exchangeClassMethod1(method1:Selector, method2:Selector){
        
        method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
    }
    
    
    //MARK: 执行某个方法
    func xwExeAction(action:Selector){
        if self.respondsToSelector(action) == true {
            let timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector:action, userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
}



/** ===========================================================================================
                                    UIScrollViewExtension
===============================================================================================*/
extension UIScrollView {
    
    var xw_offSetY:CGFloat {
        get{
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var xw_offSetX:CGFloat {
        get{
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var xw_insertTop:CGFloat {
        get{
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var xw_insertRight:CGFloat {
        get{
            return self.contentInset.right
        }
        set {
            self.contentInset.right = newValue
        }
    }
    
    var xw_insertLeft:CGFloat {
        get {
            return self.contentInset.left
        }
        set {
            self.contentInset.left = newValue
        }
    }
    var xw_insertBottom:CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var xw_contentW:CGFloat {
        get{
            return self.contentSize.width
        }
        
        set {
            self.contentSize.width = newValue
        }
    }
    
    var xw_contentH:CGFloat {
        get{
            return self.contentSize.height
        }
        
        set {
            self.contentSize.height = newValue
        }
    }
}

/** ===========================================================================================
                                    UIViewExtension
===============================================================================================*/

extension UIView {
    
    
    var xw_x:CGFloat {
        get{
            //写下面这句不会进入 死循环
            //            let a  = self.xw_x
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
            
            // 写下面这句不会死循环
            //self.frame.origin.x = x
        }
    }
    
    var xw_y:CGFloat {
        get{
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var xw_width:CGFloat {
        get{
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var xw_height:CGFloat {
        get{
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var xw_size:CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    var xw_origin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var xw_centerX:CGFloat {
        get{
            return self.center.x
        }
        
        set {
            self.center.x = newValue
        }
    }
    
    var xw_centerY:CGFloat {
        get{
            return self.center.y
        }
        
        set {
            self.center.y = newValue
        }
    }
}


/** ===========================================================================================
                                    NSDate Extension
===============================================================================================*/
extension NSDate {
    
    /** 转换NSDate->String 精确点 */
    func xwConvertStringTime() -> String {
        
        // 1.获得年月日
        let calender = NSCalendar.currentCalendar()
        
        let unitFlags = NSCalendarUnit.Day
        
        let cmp1:NSDateComponents = calender.components(unitFlags, fromDate: self)
        
        let cmp2:NSDateComponents = calender.components(unitFlags, fromDate: NSDate())
        
        let formatter = NSDateFormatter()
        
        if cmp1.day == cmp2.day {
            
            formatter.dateFormat = "今天 HH:mm"
        }else {
            formatter.dateFormat = "MM-dd HH:mm"
        }
        return "最后更新:" + formatter.stringFromDate(self)
        
    }
    
}
