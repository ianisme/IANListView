//
//  NewListView.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "NewListView.h"
#import "UUtil.h"
@implementation NewListView

- (void)startLoading
{
    [self _initTabelView];
    [self refreshList:YES];
}

- (void)refreshList:(BOOL)force
{
    // 为Yes的时候是执行自动下拉刷新
    if (force) {
        if(!_withoutRefreshHeader){
            [self.tableView headerBeginRefreshing];
            return;
        }
    }

    [_dataSource refreshHandler:^(BOOL success, id result){

        if(success){
            _isEmpty = [(NSArray *)result count] == 0;
            _isFailing = NO;
        }else{
            _isFailing = YES;
        }
        
        if (!_withoutRefreshHeader) {
            [self.tableView headerEndRefreshing];
        }

        [_tableView reloadData];
        
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEmpty || _isFailing) {
        return _tableView.frame.size.height;
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

            [_dataSource loadMoreHandler:^(BOOL success, id result){

                if (success) {
                    label.hidden = YES;
                    int64_t delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [indicatorView stopAnimating];
                        [_tableView reloadData];
                    });
                }else{
                    [indicatorView stopAnimating];
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
    if (_isEmpty) {
        static NSString *identierEmpty = @"ListViewEmptyCell";
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:identierEmpty];
        if (!emptyCell) {
            emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identierEmpty];
            emptyCell.separatorInset = UIEdgeInsetsMake(0, tableView.frame.size.width, 0, 0);
            emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.emptyView) {
                [emptyCell.contentView addSubview:self.emptyView];
            }else{
                [emptyCell.contentView addSubview:[self _emptyView]];
            }
        }
        
        return emptyCell;
    }
    
    if (_isFailing)
    {
        static NSString *identifierFailure = @"ListViewFailureCell";
        UITableViewCell *failureCell = [tableView dequeueReusableCellWithIdentifier:identifierFailure];
        if (failureCell == nil)
        {
            failureCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierFailure];
            failureCell.separatorInset = UIEdgeInsetsMake(0, tableView.frame.size.width, 0, 0);
            failureCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.failureView) {
                [failureCell.contentView addSubview:self.failureView];
            }else{
                [failureCell.contentView addSubview:[self _failureView]];
            }
        }
        
        return failureCell;
    }
    
    
    if([indexPath row] == [_dataSource numberOfRows]){
        return [self _loadingMoreCellFor:tableView cellHeight:44 cellIdentifier:@"ListloadingCell"];
    }
    return [_dataSource tableView:tableView cellForRow:[indexPath row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_withoutLoadMore && [indexPath row] == [_dataSource numberOfRows])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
//-----------------------------

#pragma mark MJRefresh Methods

- (void)headerRereshing
{
    [self refreshList:NO];
}
// ----------------------------------

#pragma -mark transition view
#define LIST_TRANSITION_EMPTY_TAG 1000
#define LIST_TRANSITION_FAIL_TAG 1001
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

- (UIView *)_emptyView
{
    return [self _viewWithtitle:_emptyText ? _emptyText : @"没有数据呀！"
                       offsetY:130 tag:LIST_TRANSITION_EMPTY_TAG];
}

- (UIView *)_failureView
{
    return [self _viewWithtitle:_failureText ? _failureText : @"数据加载失败，请检查网络！"
                        offsetY:130 tag:LIST_TRANSITION_FAIL_TAG];
}

- (UIView *)_viewWithtitle:(NSString *)title offsetY:(CGFloat)offset tag:(NSInteger)tag
{
    UIView *transitionView = [[UIView alloc] initWithFrame:self.bounds];
    transitionView.tag = tag;
    
    [transitionView addSubview:[self _centerLabelWithFrame:CGRectMake(20, offset, self.bounds.size.width - 2 * 20, 0) title:title]];
    
    return transitionView;
}

- (UILabel *)_centerLabelWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    CGRect p = label.frame;
    p.size.height = [UUtil textSize:title font:[UIFont systemFontOfSize:14.f] bounding:CGSizeMake(frame.size.width, MAXFLOAT)].height;
    label.frame = p;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor grayColor]];
    [label setText:title];
    label.numberOfLines = 0 ;
    [label setFont:[UIFont systemFontOfSize:14.f]];
    
    return label;
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
