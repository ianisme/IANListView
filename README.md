# IANListView

### 说明：
- 对UITableview的一个封装

### 功能如下：

- 1.此封装需要pod集成MJRefresh和JSONModel，可以自行修改代码
- 2.分页参数集成到datasource中
- 3.对数据为空做了有效处理

### 代码示例：

```

 	_listView = [[IANListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _listView.cellIdentifier = @"cellIdentifier";
    _listView.cellClass = NSStringFromClass([IANCustomCell class]);
    IANPageDataSource *ds = [[IANPageDataSource alloc] init];
    ds.pageSize = 20; // 每页的数量
    ds.requestBlock = ^(NSDictionary *params, void(^dataArrayDone)(BOOL, id)){
        
       		// 网络请求
       		// status 传YES(1)或者NO(0)
       		// tempArray 传网络获取的数据数组
            dataArrayDone(status,tempArray);
  
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSInteger row, NSMutableArray *dataArray){
       	// 这是就是创建cell的地方(摆脱别用判断cell为空的方法了)
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSInteger row, NSMutableArray *dataArray){
        
        // 这里就是返回高度的地方
        return (CGFloat)44.0;
    };
    
    ds.selectBlock = ^(NSInteger row, NSMutableArray *dataArray){
        
       	// 这里就是点击事件的地方
        
    };
    
    _listView.dataSource = ds;
    [self.view addSubview:_listView];
    [_listView startLoading];

```

### 效果演示（糗事百科数据演示）：

<img src="http://785j3g.com1.z0.glb.clouddn.com/github%2Fianlistview%2Fdemo.gif"  alt="效果展示by ian" height="568" width="320" />