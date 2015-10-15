# XWSwiftRefresh
---
####一句话解决刷新

![](https://raw.githubusercontent.com/boyXiong/raw/master/picture/XWSwiftRefresh/displayHowToUser.gif)

#### 使用方法 基于Xcode 7 Swift2.0
#### 支持cocoapod 
```
	//在 Podfile 写入
    source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	use_frameworks!

	pod 'XWSwiftRefresh', '~> 0.1.6'
```
#### How to use

##### 导入 import XWSwiftRefresh

```Swift

/**  最新 使用方法 */

// MARK: 默认的视图
    /** 添加上拉刷新头部控件  
        target , action 类似
        按钮的点击事件后执行的方法 button.addTarget(<#T##target: AnyObject?##AnyObject?#>, action: <#T##Selector#>, forControlEvents: <#T##UIControlEvents#>)
    */
        
    self.tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")

    //立刻上拉刷新
    self.tableView.headerView?.beginRefreshing()

    //上拉停止刷新
    self.tableView.headerView?.endRefreshing()


    //添加下拉刷新的控件
    self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")

    //立刻下拉刷新
    self.tableView.headerView?.beginRefreshing()

    //下拉拉停止刷新
    self.tableView.headerView?.endRefreshing()



// MARK: gif的视图

    var idleImages = [UIImage]()
        for (var i = 1; i<=20; i++) {
            let image = UIImage(named: String(format: "mono-black-%zd", i))
            idleImages.append(image!)
        }

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    var refreshingImages = [UIImage]()
        for (var i = 1; i<=20; i++) {
            let image = UIImage(named: String(format: "mono-black-%zd", i))
            refreshingImages.append(image!)
        }

    // 其实headerView是一个View 拿出来，更合理
    let headerView = XWRefreshGifHeader(target: self, action: "upPullLoadData")

    //这里是 XWRefreshGifHeader 类型,就是gif图片
    headerView.setImages(idleImages, duration: 0.8, state: XWRefreshState.Idle)
    headerView.setImages(refreshingImages, duration: 0.8, state: XWRefreshState.Refreshing)

    //隐藏状态栏 默认不隐藏，就显示 用户的状态
    headerView.refreshingTitleHidden = true
    //隐藏时间状态  默认隐藏，就显示 时间的状态
    headerView.refreshingTimeHidden = true
    //根据上拉比例设置透明度  默认 是 false
    headerView.automaticallyChangeAlpha = true

       
    设置 headerView
    self.tableView.headerView = headerView





//已经过期
//使用方法,添加上拉刷新
        self.tableView.addHeaderWithCallback {
            [weak self] (Void) -> () in
            if let strongSelf = self {
                
                strongSelf.downUpLoadData()
            }
        }
        
        //添加下拉刷新
        self.tableView.addFooterWithCallback {
            [weak self] (Void) -> () in
            if let strongSelf = self {
                
                strongSelf.downLoadData()
                
            }
        }

```

##### 感谢 MJRefresh AFNetwork SDWebImage KxMovie GPUImage等 好的开源框架
##### 感谢 KSImageNamed ,VV 等优秀的插件
##### 感谢开源，回报开源
##### [个人博客技术分享](http://blog.csdn.net/boyXiong)