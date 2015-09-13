# XWSwiftRefresh
一句话解决刷新
#### 使用方法
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

#### 感谢开源，回报开源
