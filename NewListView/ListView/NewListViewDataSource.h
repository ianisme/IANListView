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
- (void)refresh:(BOOL)force handler:(void (^)(BOOL success, id result))refreshDone;
- (void)loadMore:(void (^)(BOOL success, id result))loadMoreDone;
- (BOOL)hasMore;
- (void)clearData;
- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;
- (CGFloat)heightOfRow:(NSInteger)row;

@end
