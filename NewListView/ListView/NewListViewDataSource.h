//
//  NewListViewDataSource.h
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol NewListViewDataSource <NSObject>

@property (nonatomic, readonly) NSMutableArray *dataArray;

@required
- (NSInteger)numberOfRows;
- (CGFloat)heightOfRow:(NSInteger)row;
- (void)refreshHandler:(void (^)(BOOL success, id result))refreshDone;
- (void)loadMoreHandler:(void (^)(BOOL success, id result))loadMoreDone;
- (BOOL)hasMore; //是否有更多
- (void)clearData;
- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;

@end
