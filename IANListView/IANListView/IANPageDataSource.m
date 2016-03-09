//
//  IANPageDataSource.m
//  IANListView
//
//  Created by ian on 15/2/25.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "IANPageDataSource.h"

@interface IANPageDataSource()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) BOOL hasMore;
@property (nonatomic) BOOL isEmpty;
@property (nonatomic) BOOL isFailing;
@property (nonatomic) BOOL withoutLoadMore;

@end

@implementation IANPageDataSource

#pragma mark - public methods
- (void)refreshDataHandler:(void (^)())refreshDone;
{
    _page = 1;
    NSMutableDictionary *params = [self _pageArgs];
    
    _requestBlock(params, ^(BOOL success, id result)
                  {
                      if (success) {
                          _dataArray = [[NSMutableArray alloc] initWithArray:result];
                          _hasMore = _dataArray.count >= _pageSize;
                      }
                      
                      if(success){
                          _isEmpty = [(NSArray *)result count] == 0;
                          _isFailing = NO;
                      }else{
                          _isFailing = YES;
                      }
                      
                      refreshDone();
                  }
                  );
}

- (void)tableViewDataSourceAndDelegate:(UITableView *)tableView andWithoutLoadMore:(BOOL)withoutLoadMore;
{
    _withoutLoadMore = withoutLoadMore;
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)clearData
{
    _dataArray = nil;
    _hasMore = NO;
}


#pragma mark - NewListViewDataSource protocol-
- (NSInteger)numberOfRows
{
    return _dataArray.count;
}

- (void)loadMoreHandler:(void (^)(BOOL success, id result))loadMoreDone
{
    _page += 1;
    
    _requestBlock([self _pageArgs], ^(BOOL success, id result){
        if (success) {
            NSMutableArray *newArray = (NSMutableArray *)result;
            NSInteger count = newArray.count;
            count = newArray.count;
            [_dataArray addObjectsFromArray:newArray];
            _hasMore =  count >= _pageSize;
        }
        
        loadMoreDone(success, result);
    }
                  );
}

- (NSMutableDictionary *)_pageArgs
{
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    args[@"page"] = @(_page);
    args[@"page_size"] = @(_pageSize);
    return args;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEmpty || _isFailing) {
        return tableView.frame.size.height;
    }
    if (self.calculateHeightofRowBlock) {
        return self.calculateHeightofRowBlock(indexPath, self.dataArray);
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] < [self numberOfRows]) {
        if (self.selectBlock) {
            self.selectBlock(indexPath, self.dataArray);
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [self numberOfRows]) {
        if (_hasMore) {
            UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:99]; //小菊花
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            label.hidden = YES;
            [indicatorView startAnimating];
            
            [self loadMoreHandler:^(BOOL success, id result){
                
                if (success) {
                    label.hidden = YES;
                    int64_t delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [indicatorView stopAnimating];
                        [tableView reloadData];
                    });
                }else{
                    [indicatorView stopAnimating];
                    label.hidden = NO;
                    label.text = @"加载失败";
                }
                
                
            }];
        }else{
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            if (tableView.contentSize.height > cell.frame.size.height + tableView.frame.size.height) {
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
    NSInteger rawNum = [self numberOfRows];
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
    
    
    if([indexPath row] == [self numberOfRows]){
        return [self _loadingMoreCellFor:tableView cellHeight:44 cellIdentifier:@"ListloadingCell"];
    }
    
    if (self.creatCellBlock) {
        return self.creatCellBlock(tableView, indexPath, self.dataArray);
    }else{
        return [[UITableViewCell alloc]init];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_withoutLoadMore && [indexPath row] == [self numberOfRows])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
//-----------------------------

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
    UIView *transitionView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    transitionView.tag = tag;
    
    [transitionView addSubview:[self _centerLabelWithFrame:CGRectMake(20, offset, [UIScreen mainScreen].bounds.size.width - 2 * 20, 0) title:title]];
    
    return transitionView;
}

- (UILabel *)_centerLabelWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    CGRect p = label.frame;
    p.size.height = [self textSize:title font:[UIFont systemFontOfSize:14.f] bounding:CGSizeMake(frame.size.width, MAXFLOAT)].height;
    label.frame = p;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor grayColor]];
    [label setText:title];
    label.numberOfLines = 0 ;
    [label setFont:[UIFont systemFontOfSize:14.f]];
    
    return label;
}

- (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
{
    if (!(text && font) || [text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return CGRectIntegral(rect).size;
}


@end
