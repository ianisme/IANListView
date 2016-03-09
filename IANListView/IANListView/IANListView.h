//
//  IANListView.h
//  IANListView
//
//  Created by ian on 15/2/25.
//  Copyright © 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IANPageDataSource.h"
#import "MJRefresh.h"

@interface IANListView : UIView

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *cellClass;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) IANPageDataSource *dataSource;

@property (nonatomic) BOOL withoutRefreshHeader; //是否开启下拉刷新
@property (nonatomic) BOOL withoutLoadMore; // 是否开启上拉加载更多

- (void)startLoading; //加载的初始化（必须实现）
- (void)refreshList:(BOOL)force; // force为Yes则实现自动的下拉刷新，为No的时候手动下拉刷新

@end
