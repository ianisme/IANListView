//
//  NewListView.h
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedDataSource.h"
#import "MJRefresh.h"
@interface NewListView : UIView<UITableViewDataSource, UITableViewDelegate>
{
@private
    BOOL _isEmpty;
    BOOL _isFailing;
}
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) id<NewListViewDataSource> dataSource;
@property (nonatomic, copy) NSString *emptyText; //数据为空时显示的文字
@property (nonatomic, strong) UIView *emptyView; //数据为空时显示的View（文字设置此时失效）
@property (nonatomic, copy) NSString *failureText; //数据为失败时显示的文字
@property (nonatomic, strong) UIView *failureView; //数据为失败时显示的View（文字设置此时失效）
@property (nonatomic) BOOL withoutRefreshHeader; //是否开启下拉刷新
@property (nonatomic) BOOL withoutLoadMore; // 是否开启上拉加载更多

- (void)startLoading; //加载的初始化（必须实现）
- (void)refreshList:(BOOL)force; // force为Yes则实现自动的下拉刷新，为No的时候手动下拉刷新

@end
