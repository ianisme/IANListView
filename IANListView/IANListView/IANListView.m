//
//  IANListView.m
//  IANListView
//
//  Created by ian on 15/2/25.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "IANListView.h"
#import "IANCustomCell.h"

@implementation IANListView

#pragma mark - public method
- (void)startLoading
{
    [self _initTabelView];
    [self refreshList:YES];
    [self.dataSource tableViewDataSourceAndDelegate:self.tableView andWithoutLoadMore:_withoutLoadMore];
}

- (void)refreshList:(BOOL)force
{
    // 为Yes的时候是执行自动下拉刷新
    if (force) {
        if(!_withoutRefreshHeader){
            [self.tableView.mj_header beginRefreshing];
            return;
        }
    }
    
    [_dataSource refreshDataHandler:^{
        if (!_withoutRefreshHeader) {
            [self.tableView.mj_header endRefreshing];
        }
        
        [_tableView reloadData];
    }];
}


#pragma mark - MJRefresh Methods

- (void)headerRereshing
{
    [self refreshList:NO];
}

#pragma mark - private method

- (void)_initTabelView
{
    if (_tableView) {
        return;
    }
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self _setExtraCellLineHidden:tableView];
        if (_cellIdentifier) {
            const char *classChar =[_cellClass UTF8String];
            [tableView registerClass:objc_getClass(classChar) forCellReuseIdentifier:_cellIdentifier];
        }
        
        [self addSubview:tableView];
        tableView;
    });
    
    if (!_withoutRefreshHeader) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];

        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=60; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [idleImages addObject:image];
        }
        [header setImages:idleImages forState:MJRefreshStateIdle];
        
        // 设置正在刷新状态的动画图片
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [refreshingImages addObject:image];
        }
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        self.tableView.mj_header = header;
    }
    // 没有更多了
    if (_withoutLoadMore) {
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 10)];
    }else{
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

// 没有数据的时候将分割线隐藏
- (void)_setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}


@end
