//
//  NewListView.h
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedDataSource.h"
@interface NewListView : UIView<UITableViewDataSource, UITableViewDelegate>
{
@private
    BOOL _isEmpty;
    BOOL _isFailing;
}
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) id<NewListViewDataSource> dataSource;
@property (nonatomic, copy) NSString *empryText;
@property (nonatomic) BOOL withoutRefreshHeader; //是否开启下拉刷新
@property (nonatomic) BOOL withoutLoadMore; // 是否开启上拉加载更多

- (void)startLoading;
- (void)refreshList:(BOOL)force;
- (void)reloadData;

@end
