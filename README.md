<h2> NewListView</h2>
<h4>说明： NewListView将UITableView的方法全部提供了外部接口，并提供NewPagedDataSource.h以进行扩展自定义。</h4>
- NewListView.h  
` 
@property (nonatomic, copy)NSString *emptyText; //数据为空时显示的文字  
@property (nonatomic, strong) UIView *emptyView; //数据为空时显示的View（文字设置此时失效）  
@property (nonatomic, copy) NSString *failureText; //数据为失败时显示的文字  
@property (nonatomic, strong) UIView *failureView; //数据为失败时显示的View（文字设置此时失效）  
@property (nonatomic) BOOL withoutRefreshHeader; //是否开启下拉刷新  
@property (nonatomic) BOOL withoutLoadMore; // 是否开启上拉加载更多  
`
- NewPagedDataSource.h  
`
@property (nonatomic, copy) TRequestBlock requestBlock;//请求网络  
@property (nonatomic, copy) TableViewSelectBlock selectBlock;//Cell的点击事件  
@property (nonatomic, copy) CreatTableViewCellBlock creatCellBlock;//创建Cell  
@property (nonatomic, copy) CalculateHeightOfRow calculateHeightofRowBlock;// Cell的高度  
`
