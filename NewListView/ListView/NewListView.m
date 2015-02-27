//
//  NewListView.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "NewListView.h"
#import "ODRefreshControl.h"
@implementation NewListView

- (void)startLoading
{
    [self _initTabelView];
    [self refreshList:NO]; //默认为NO
}

- (void)reloadData
{
    if(_tableView){
        _isEmpty = _dataSource.dataArray == nil || _dataSource.dataArray.count == 0;
        [_tableView reloadData];
    }
}

- (void)refreshList:(BOOL)force
{
    _isLoading = YES;
    if (!force) {
        
    }
    
    [_dataSource refresh:force handler:^(BOOL success, id result){
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEmpty || _isFailing) {
        return 0;
    }
    
    if ([_dataSource respondsToSelector:@selector(heightOfRow:)]) {
        return [_dataSource heightOfRow:[indexPath row]];
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] < [_dataSource numberOfRows]) {
        if ([_dataSource respondsToSelector:@selector(tableView:didSelectRow:)]) {
            [_dataSource tableView:tableView didSelectRow:[indexPath row]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource tableView:tableView cellForRow:[indexPath row]];
}
//-----------------------------

#pragma mark - UIScrollView Delegate -


//---------------------------------
#pragma mark ODRefreshControl Methods

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshList:YES];
        [refreshControl endRefreshing];
    });
}
// ----------------------------------


- (void)_initTabelView
{
    if (_tableView) {
        return;
    }
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        tableView;
    });
    
    if (!_withoutRefreshHeader) {
        ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
        [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
}
@end
