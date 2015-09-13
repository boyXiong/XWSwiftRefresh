//
//  XWRefreshFooter.swift
//  XWRefresh
//
//  Created by Xiong Wei on 15/9/11.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//

import UIKit

typealias colsureType = ()->()

/** footer状态 */
enum XWRefreshFooterState:Int{
    /**普通闲置状态 */
    case Idle = 1
    /**正在刷新中的状态 */
    case Refreshing = 2
    /**没有数据需要加载 */
    case NoMoreData = 3
}


class XWRefreshFooter: XWRefreshComponent {
    
    //MARK: 公有的 提供外界访问的
    
    /** 提示没有更多数据 */
    func noticeNoMoreData(){ self.state = .NoMoreData }
    
    /** 进入刷新状态 */
    override func beginRefreshing(){ self.state = .Refreshing }
    /** 结束刷新状态 */
    override func endRefreshing(){ self.state = .Idle}
    /** 是否正在刷新 */
    override func isRefreshing(){ self.state = .Refreshing }

    
    /** 从新刷新控件的状态交给子类重写 默认闲置状态 */
    var state:XWRefreshFooterState = .Idle {
        
        //观察状态的改变 来进行相应的操作
        willSet{
            if state == newValue {return}
            
            switch newValue {
            case .Idle:
                self.noMoreLabel.hidden = true
                self.stateLabel.hidden = true
                self.loadMoreButton.hidden = false
            case .Refreshing:
                self.loadMoreButton.hidden = true
                self.noMoreLabel.hidden = true
                if !self.stateHidden { self.stateLabel.hidden = false}
                //回调
                self.refreshingBlock()
            case .NoMoreData:
                self.loadMoreButton.hidden = true;
                self.noMoreLabel.hidden = false;
                self.stateLabel.hidden = true;
            }
            
        }
    }
    
    /** 是否隐藏状态标签 */
    var stateHidden:Bool = false {
        didSet{
            self.stateLabel.hidden = stateHidden
            //重写布局子控件
            self.setNeedsLayout()
        }
    }
    /** 监听父类的属性 font */
    override var font:UIFont?{
        didSet{
            self.loadMoreButton.titleLabel!.font = font;
            self.noMoreLabel.font = font;
            self.stateLabel.font = font;
        }
    }
    
    /** 监听父类的属性 textColor */
    override var textColor:UIColor?{
        didSet{
            self.stateLabel.textColor = textColor;
            self.loadMoreButton.setTitleColor(textColor, forState: UIControlState.Normal)
            self.noMoreLabel.textColor = textColor;
        }
    }
    
    
    
    /** 设置footer状态下的文字*/
    func setTitle(title:String?, state:XWRefreshFooterState){
    
        if let realTitle = title {
            switch state {
            case .Idle:
                self.loadMoreButton.setTitle(realTitle, forState: UIControlState.Normal)
                self.loadMoreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                break
            case .Refreshing:
                self.stateLabel.text = realTitle
                break
            case .NoMoreData:
                self.noMoreLabel.text = realTitle
            }
        }
    }
    
    /** 是否自动刷新,默认 true */
    var automaticallyRefresh:Bool = true
    
    /** 当底部控件出现多少时就自动刷新(默认为0.5，也就是底部控件完全出现一半的时候时，才会自动刷新) */
    var appearencePercentTriggerAutoRefresh:CGFloat = 0.5
    
    //MARK: 私有
    /** 显示转态的 lable 文字 */
    private lazy var stateLabel:UILabel = {
        [unowned self] in
        let stateLable = UILabel()
        stateLable.backgroundColor = UIColor.clearColor()
        stateLable.textAlignment = NSTextAlignment.Center
        self.addSubview(stateLable)
        return stateLable
    }()
    
    /** 显示没有更多 lable 文字 */
    private lazy var noMoreLabel:UILabel = {
        [unowned self] in
        let noMoreLabel = UILabel()
        noMoreLabel.backgroundColor = UIColor.clearColor()
        noMoreLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(noMoreLabel)
        return noMoreLabel
        }()
    
    /** 点击可以加载更多 按钮 */
    private lazy var loadMoreButton:UIButton = {
        [unowned self] in
        let loadMoreButton = UIButton()
        loadMoreButton.backgroundColor = UIColor.clearColor()
        loadMoreButton.addTarget(self, action: "buttonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(loadMoreButton)
        return loadMoreButton
        }()
    
    /** 点击可以加载更多 执行的方法 */
    func buttonClick(){
        
        if self.state != XWRefreshFooterState.Refreshing {
            self.state = .Refreshing

        }
    }
    
    /** 即将执行的代码块 */
    private var willExeColsuresM:Array<colsureType> = []
    
    

    //MARK:  重写父类方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化文字
        self.setTitle(XWRefreshFooterStateIdleText, state: .Idle)
        self.setTitle(XWRefreshFooterStateRefreshingText, state: .Refreshing)
        self.setTitle(XWRefreshFooterStateNoMoreDataText, state: .NoMoreData)
        //初始状态
        self.noMoreLabel.hidden = true
        self.stateLabel.hidden = true
        self.loadMoreButton.hidden = false

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
       
        super.willMoveToSuperview(newSuperview)
        
        //移除旧的监听
        self.superview?.removeObserver(self, forKeyPath: XWRefreshContentSize, context: nil )
         self.superview?.removeObserver(self, forKeyPath: XWRefreshPanState, context: nil )
        
        if let realSuperView = newSuperview {
            //1.如果存在 就添加到父控件中去
            //1.1 添加监听
            realSuperView.addObserver(self, forKeyPath: XWRefreshContentSize, options: NSKeyValueObservingOptions.New, context: nil)
            realSuperView.addObserver(self, forKeyPath: XWRefreshPanState, options: NSKeyValueObservingOptions.New, context: nil)
            
            
            //1.2.添加到父控件
            self.xw_height = XWRefreshFooterHeight
            
            self.scrollView.contentInset.bottom += self.xw_height
            
//            realSuperView.addSubview(self)
            
            //1.3从新调整frame
            self.adjustFrameWithContentSize()
        }
        
    }
    
    //根据能滚动的距离调整
    private func adjustFrameWithContentSize(){
        
        self.xw_y = self.scrollView.contentSize.height
    }
    
    //重写layoutSubview
    override func layoutSubviews() {
        super.layoutSubviews()
        //给要显示的控件设置frame
        self.noMoreLabel.frame = self.bounds
        self.stateLabel.frame = self.bounds
        self.loadMoreButton.frame = self.bounds

    }
    
    //监听属性的改变
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //1.遇到不能交互的直接返回
        if !self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.state == .NoMoreData { return }
        
        
        //contenInset.top 是一开始的内部的 内边距 有导航条的情况下是 64
        // contentOffset .以 内容也就是 以 真正的content  到 frame 来计算偏移
        // contentOffset.y = content.y 也就是内容的 y 值 contentOffset.x 也就是 内容的 x 值
        
        /*
        frame 相当于 墙上的一个窗户
        content 决定 窗户里面的人物
        */
        
        
        //2.    根据contentOffset 来调整state状态
       
        switch keyPath {
            
             //2.1   如果是监听到 手式
        case XWRefreshPanState :
            //2.1.1 抬起
            if self.scrollView.panGestureRecognizer.state == UIGestureRecognizerState.Ended {
                
                // 向上拖拽
                func draggingUp(){
                    //如果是向 上拖拽 刷新
                    if self.scrollView.contentOffset.y > -self.scrollView.contentInset.top {
                        beginRefreshing()
                    }
                }
                
                //2.2.1.1 不够一个屏幕的滚动 top + content.height 就是内容显示的高度
                if self.scrollView.contentInset.top +
                    self.scrollView.contentSize.height < self.scrollView.xw_height {
                        
                        draggingUp()
                        
                        //2.1.1.2 超出一个屏幕 也就是scrollView的
                }else {
                    //拖拽到了底部
                    if self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom  == self.scrollView.xw_height {
                        
//                        beginRefreshing()
                        draggingUp()
                        
                    }
                    
                }
            }
            
        case XWRefreshContentOffset:
            
            //如果不是正在刷新的状态,且 是自动刷新
            if self.state != XWRefreshFooterState.Refreshing && self.automaticallyRefresh{
                //调整State
                self.adjustStateWithContentOffset()
            }
        case XWRefreshContentSize:
            
            self.adjustFrameWithContentSize()
            
            
        default: break
            
        }
        
    }
    
    //根据 contentOffset 调整 状态
    private func adjustStateWithContentOffset(){
        if self.xw_y == 0 {return}
        
        //超过屏幕
        if self.scrollView.contentInset.top +
            self.scrollView.contentSize.height > self.scrollView.xw_height {
                //拖拽到了底部, appearencePercentTriggerAutoRefresh 底部显示多少的 百分比，默认是不用显示
                
                //TODO: 计算公式，判断是不是在拖在到了底部
                //去掉 + self.scrollView.contentInset.top
                if self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.bottom + self.xw_height * self.appearencePercentTriggerAutoRefresh - self.xw_height <= self.scrollView.xw_height {
                    
                    //当底部控件完全出现才刷新
                    self.beginRefreshing()
                }
        }
        
    }
    
//    var colsure:NSMutableArray<()->()>!
    
    
    //MARK: 给父类 hidden 添加观察者属性 这里设计到一些知识
   override var hidden:Bool{
    
        //拦截
        willSet{
            // 最后一次设置的 hidden
            let lastHidden = self.hidden
            //将常量 写在闭包的外面
            let h = self.xw_height
            self.willExeColsuresM.append({
                
                [unowned self] in
                //之前的是不隐藏，现在是隐藏，所以要减去之前的 高度
                if !lastHidden && newValue {
                    self.state = XWRefreshFooterState.Idle
                    self.scrollView.contentInset.bottom -= h
                }else if lastHidden && !newValue {
                    self.scrollView.contentInset.bottom += h
                    self.adjustFrameWithContentSize()
                    
                }
            })
            // 放到drawRect是为了延迟执行，防止因为修改了inset，导致循环调用数据源方法
            self.setNeedsDisplay()
        }
    
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //执行闭包
        for calsure in self.willExeColsuresM {
            calsure()
        }
        //移除闭包
        self.willExeColsuresM.removeAll()
    }

}
