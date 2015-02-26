//
//  NewPagedDataSource.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "NewPagedDataSource.h"

@implementation NewPagedDataSource

#pragma mark - NewListViewDataSource protocol-
- (NSInteger)numberOfRows
{
    return _dataArray.count;
}

- (void)refresh:(BOOL)force handler:(void (^)(BOOL success, id result))refreshDone
{
    _page = 1;
    NSMutableDictionary *params = [self _pageArgs];
    params[@"force_refresh"] = @(force);
    
    _requestBlock(params, ^(BOOL success, id result)
                        {
                            if (success) {
                                _dataArray = [[NSMutableArray alloc] initWithArray:   result];
                                _hasMore = _dataArray.count >= _pageSize;
                            }
                      
                            refreshDone(success, result);
                        }
    );
}

- (void)loadMore:(void (^)(BOOL success, id result))loadMoreDone
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

- (BOOL)hasMore
{
    return _hasMore;
}

- (void)clearData
{
    _dataArray = nil;
    _hasMore = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row
{
    if (self.selectBlock) {
        self.selectBlock(row, self.dataArray);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row
{
    if (self.creatCellBlock) {
        return self.creatCellBlock(tableView, row, self.dataArray);
    }else{
        return [[UITableViewCell alloc]init];
    }
}

- (CGFloat)heightOfRow:(NSInteger)row
{
    if (self.calculateHeightofRowBlock) {
        return self.calculateHeightofRowBlock(row, self.dataArray);
    }else{
        return 44;
    }
}

- (NSMutableDictionary *)_pageArgs
{
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    args[@"page"] = @(_page);
    args[@"page_size"] = @(_pageSize);
    return args;
}


@end
