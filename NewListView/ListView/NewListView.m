//
//  NewListView.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "NewListView.h"

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
- (void)viewDidAppearReloadData
{
    [self.tableView headerBeginRefreshing];
}

- (void)refreshList:(BOOL)force
{
    if (!force) {
        
    }
    
    [_dataSource refresh:force handler:^(BOOL success, id result){
        [self.tableView headerEndRefreshing];
        [self reloadData];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [_dataSource numberOfRows]) {
        if ([_dataSource hasMore]) {
            UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:99]; //小菊花
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            label.hidden = YES;
            [indicatorView startAnimating];
            
            [_dataSource loadMore:^(BOOL success, id result){
                [indicatorView stopAnimating];
                if (success) {
                    label.hidden = YES;
                    [self reloadData];
                }else{
                    label.hidden = NO;
                    label.text = @"加载失败";
                }
            
            }];
        }else{
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            if (_tableView.contentSize.height > cell.frame.size.height + tableView.frame.size.height) {
                label.hidden = NO;
            }else{
                label.hidden = YES;
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isFailing || _isEmpty){
        return 1;
    }
    NSInteger rawNum = [_dataSource numberOfRows];
    if (rawNum > 0) {
        return _withoutLoadMore ? rawNum : rawNum + 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == [_dataSource numberOfRows]){
        return [self _loadingMoreCellFor:tableView cellHeight:44 cellIdentifier:@"ListloadingCell"];
    }
    return [_dataSource tableView:tableView cellForRow:[indexPath row]];
}
//-----------------------------

#pragma mark MJRefresh Methods

- (void)headerRereshing
{
    [self refreshList:YES];
}
// ----------------------------------

#pragma -mark transition view
- (UITableViewCell *)_loadingMoreCellFor:(UITableView *)tableView cellHeight:(CGFloat)height cellIdentifier:(NSString *)identifier
{
    UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!loadingCell) {
        loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        loadingCell.separatorInset = UIEdgeInsetsMake(0, tableView.frame.size.width, 0, 0);
        CGFloat indicatorSize = 20;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake((tableView.frame.size.width - indicatorSize) / 2, (height - indicatorSize) / 2, indicatorSize, indicatorSize);
        indicatorView.tag = 99;
        indicatorView.hidesWhenStopped = YES;
        [loadingCell addSubview:indicatorView];
        
        height = 44;
        CGSize labelSize = CGSizeMake(200, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 2 - labelSize.width / 2,
                                                                   (height - labelSize.height) / 2, labelSize.width, labelSize.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor grayColor];
        label.text = @"没有更多了";
        label.tag = 100;
        label.hidden = YES;
        [loadingCell addSubview:label];
    }
    return loadingCell;
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
        [self _setExtraCellLineHidden:tableView];
        [self addSubview:tableView];
        tableView;
    });
    
    if (!_withoutRefreshHeader) {
        [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
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
@end
