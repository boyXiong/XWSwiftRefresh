//
//  UIViewExtension-XW.swift
//  01-drawingBoard
//
//  Created by Xiong Wei on 15/8/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  增加frame 快速访问计算属性

import UIKit


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
