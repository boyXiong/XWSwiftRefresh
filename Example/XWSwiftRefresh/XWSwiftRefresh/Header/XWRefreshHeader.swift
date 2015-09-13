//
//  XWRefreshHeader.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/8.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit


// 下拉刷新控件的状态
enum XWRefreshHeaderState:Int{
    /** 普通闲置状态 */
    case Idle = 1
    /** 松开就可以进行刷新的状态 */
    case Pulling = 2
    /** 正在刷新中的状态 */
    case Refreshing = 3
    
}


class XWRefreshHeader: XWRefreshComponent {
    
    //MARK: 公开的
    
    /** 利用这个key来保存上次的刷新时间（不同界面的刷新控件应该用不同的dateKey，以区分不同界面的刷新时间） */
    var dateKey:NSString!
    /** 利用这个colsure来决定显示的更新时间 */
    var updatedTimeTitle = { (updatedTime:NSDate) -> NSString in return ""}
    
    /** 辅助记录 旧值 */
    private var oldState:XWRefreshHeaderState!

    //MARK: 改变状态后
    /** 刷新控件的状态 */
    var state:XWRefreshHeaderState?{
        

        willSet{
            //保存旧值
            self.oldState = state
        }
        
        didSet{
            
            //状态和以前的一样就不用改变
            if oldValue == state {
                return
            }
            
            if let realState = state {
                                
                //根据状态设置文字
                stateLabel.text = self.stateTitles[String(realState)] as? String
                
                switch realState {
                    /** 如果是普通闲置 */
                    case .Idle :
                    
                        //判断 之前的刷新是什么样式
                        if oldState == XWRefreshHeaderState.Refreshing {
                            
                            // 保存刷新时间
                            self.updatedTime = NSDate()
                    
                            UIView.animateWithDuration(XWRefreshSlowAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction , animations: { () -> Void in
                            
                                self.scrollView.contentInset.top -= self.xw_height
                            
                            }, completion: nil)
                        }
                    
                    case .Refreshing:
                    
                        UIView.animateWithDuration(XWRefreshFastAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                            
                            
                            //MARK 增加滚动区域
                            // 增加滚动区域
                            let top = (self.scrollViewOriginalInset?.top)! + self.xw_height;
                            
                            
                            self.scrollView.contentInset.top = top;

                            // 设置滚动位置
                            self.scrollView.contentOffset.y = -top;
                            
                            
                            }, completion: { (result) -> Void in
                                
                            // 回调
                            self.refreshingBlock()
                                
                                
                        })
                    
                    default : break
                }
                
            }
            
        }
    }
    
    /** 是否隐藏状态标签 */
    var stateHidden:Bool = false
    
    /** 是否隐藏刷新时间标签 */
    var updatedTimeHidden:Bool = false
    
    /** 下拉的百分比(交给子类重写) */
    var pullingPercent:CGFloat?;
    
    
    /**
    * 设置state状态下的状态文字内容title(别直接拿stateLabel修改文字)
    */
    func setTitle(title:NSString?, state:XWRefreshHeaderState){
        
        if let tmpTitle = title {
            
            self.stateTitles[String(state)] = tmpTitle
        
        } else {return}
        
        // 刷新当前状态的文字
        self.stateLabel.text = self.stateTitles[String(self.state)] as? String;

    }
    
    
    
    
    //MARK 私有的
    
    //状态文字
    private lazy var stateTitles:NSMutableDictionary = { return  NSMutableDictionary()}()
    
    /** 显示上次刷新时间的标签 */
    private lazy var updatedTimeLabel:UILabel = {
        
            //进入闭包，对self 进行弱引用
            [weak self] in
        
            let updatedTimeLabel = UILabel();
            updatedTimeLabel.backgroundColor = UIColor.clearColor();
            updatedTimeLabel.textAlignment = NSTextAlignment.Center;
            //初始化，完全第一次
            updatedTimeLabel.text = "最后更新:无记录"
            if let strongSelf = self {
                strongSelf.addSubview(updatedTimeLabel)
            }
    
            return updatedTimeLabel
        
        }()
    
    /** 显示上次刷新时间的标签 */
    private lazy var stateLabel:UILabel = {
        
            //进入闭包，对self 进行弱引用
            [weak self] in
            
            let stateLabel = UILabel();
            stateLabel.backgroundColor = UIColor.clearColor();
            stateLabel.textAlignment = NSTextAlignment.Center;
            
            if let strongSelf = self {
                strongSelf.addSubview(stateLabel)
            }
            
            return stateLabel
        
        }()

    
    /** 设置最后的更新时间 */
    private var updatedTime:NSDate?{
        
        didSet{
           self.didSetUpdatedTime()
        }
        
    }
    
    
    /** 通过观察者调用这个方法 */
    private func didSetUpdatedTime(){
        
        //1.取出真正的值，如果有值
        if let realTime  = self.updatedTime {
            //1.1进行存储
            NSUserDefaults.standardUserDefaults().setObject(realTime, forKey: self.dateKey as String)
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        
        //2.判断闭包有没有值, 如果有值就调用
        
        
        if let realTime  = self.updatedTime {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let time = formatter.stringFromDate(realTime)
            
            self.updatedTimeLabel.text = "最后更新:" + time
            
        }else{
            
            self.updatedTimeLabel.text = "最后更新:无记录"
        }

    }
    
    //MARK 初始化方法
    override init(frame: CGRect) {
        // 设置默认的dateKey(赶在父类init之前)
        self.dateKey = XWRefreshHeaderUpdatedTimeKey

        super.init(frame: frame)
        //1.设置初始化转态
        self.state = XWRefreshHeaderState.Idle
        // 初始化文字
        self.setTitle(XWRefreshHeaderStateIdleText, state: XWRefreshHeaderState.Idle)
        self.setTitle(XWRefreshHeaderStatePullingText, state: XWRefreshHeaderState.Pulling)
        self.setTitle(XWRefreshHeaderStateRefreshingText, state: XWRefreshHeaderState.Refreshing)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 重写父类方法 willMoveToSuperview
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        self.xw_height = XWRefreshHeaderHeight
    }
    
    //MARK: 重写 layout 来改变位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //1.设置自己的位置
        self.xw_y = -self.xw_height
        
        //2.如果两个标签都隐藏
        if self.stateHidden && self.updatedTimeHidden { return }
        //3.显示状态
        if self.stateHidden {
            //只显示状态
            self.updatedTimeLabel.frame = self.bounds
        }else if self.updatedTimeHidden {
            //只显示时间
            self.stateLabel.frame = self.bounds
        }else{
            //都显示
            let h = self.xw_height * 0.55
            let w = self.xw_width
            
            self.stateLabel.frame = CGRectMake(0, 0, w , h )
            
            self.updatedTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame), w , h )
            
        }
        
    }
    
    // 监听
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //1.遇到这种情况就直接返回
        if !self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.state == XWRefreshHeaderState.Refreshing { return }
        
        //2.根据contentOffset调整state
        if let realKeyPath = keyPath {
            
            if realKeyPath == XWRefreshContentOffset {
                
                self.adjustStateWithContentOffset()
            }
        }
    }
    
    
    //MARK 根据 contentOffset调整state 后面只需要实现 观察 状态 来重写
    private func adjustStateWithContentOffset(){
        
        if self.state != XWRefreshHeaderState.Refreshing {
            // 在刷新过程中，跳转到下一个控制器时，contentInset可能会变
            self.scrollViewOriginalInset = scrollView.contentInset;
        }
        
        
        // 当前的contentOffset
        let offsetY:CGFloat = self.scrollView.contentOffset.y
        
        
        // 头部控件刚好出现的offsetY
        var happenOffsetY:CGFloat = 0
        
        // 判断有没有值 UIEdgeInsets 刚开始的 UIEdgeInsets
        if let tmp = self.scrollViewOriginalInset {
            
            happenOffsetY = -tmp.top
            
        }
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if offsetY >= happenOffsetY {return }
        
        // 普通 和 即将刷新 的临界点
        let  normal2pullingOffsetY = happenOffsetY - self.xw_height
        
        /*
            在有导航条的情况下 所以继承 UIScrollView的 bounds 的 y 值都会变成 -64 ,也就是
        
            content 内容的 Y 值向下移动了， contenInst 打印的时候 bounds并没有改变，tableView
        
        */
        
        

        // 还在拖拽中
        if self.scrollView.dragging {
            
            // 计算百分比
            self.pullingPercent = (happenOffsetY - offsetY) / self.xw_height;
            
            // 如果当前的state 等于正常 也就是没有刷新的state 且 y 值 已经
            if self.state == XWRefreshHeaderState.Idle && offsetY < normal2pullingOffsetY {
                
                
                // 转为即将刷新状态
                self.state = XWRefreshHeaderState.Pulling;
                
                
            } else if self.state == XWRefreshHeaderState.Pulling && offsetY >= normal2pullingOffsetY  {
                
                // 转为普通状态
                self.state = XWRefreshHeaderState.Idle;
            }
            
            
            } else if (self.state == XWRefreshHeaderState.Pulling) {// 即将刷新 && 手松开
            
                self.pullingPercent = 1.0;
                // 开始刷新
                self.state = XWRefreshHeaderState.Refreshing;
            
            } else {
            
                self.pullingPercent = (happenOffsetY - offsetY) / self.xw_height;
            }
        
    }
    
    override func beginRefreshing() {
        self.state = XWRefreshHeaderState.Refreshing;
    }
    
    override func endRefreshing() {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.state = XWRefreshHeaderState.Idle;
        }
    
    }
}





