# IANListView

### 说明：
- 简单实现一个炫酷的个人中心界面

### 功能如下：

- 1.集成下拉刷新（项目中有MJRefresh的童鞋，请自行删除）
- 2.分页参数集成到datasouce中
- 3.对数据为空做了有效处理

### 代码示例：

```

 	_listView = [[IANListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    IANPageDataSource *ds = [[IANPageDataSource alloc] init];
    ds.pageSize = 20;
    ds.requestBlock = ^(NSDictionary *params, void(^dataArrayDone)(BOOL, id)){
        
       		// 网络请求
       		// status 传YES(1)或者NO(0)
       		// tempArray 传网络获取的数据数组
            dataArrayDone(status,tempArray);
  
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSInteger row, NSMutableArray *dataArray){
       	// 这是就是创建cell的地方
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