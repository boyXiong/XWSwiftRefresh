# XWSwiftRefresh
一句话解决刷新
#### 使用方法 基于Xcode 7 Swift2.0
#### cocoapod 暂时不是Swift 2.0 检测 ,所以 将 XWSwiftRefresh文件夹 拖拽到项目中就可以使用 
```Swift
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
![](http://img.blog.csdn.net/20150913003153348)

#### 感谢 MJRefresh AFNetwork SDWebImage KxMovie GPUImage等 好的开源框架
#### 感谢 KSImageView ,VV 等优秀的插件
#### 感谢开源，回报开源
