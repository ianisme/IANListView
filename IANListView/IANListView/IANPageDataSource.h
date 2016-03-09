//
//  IANPageDataSource.h
//  IANListView
//
//  Created by ian on 15/2/25.
//  Copyright © 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TRequestBlock)(NSDictionary *, void(^)(BOOL successful, id result));
typedef UITableViewCell * (^CreatTableViewCellBlock)(UITableView *, NSIndexPath *, id);
typedef CGFloat (^CalculateHeightOfRow)(NSIndexPath *, id);
typedef void (^TableViewSelectBlock)(NSIndexPath *, id);

@interface IANPageDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *emptyText; //数据为空时显示的文字
@property (nonatomic, strong) UIView *emptyView; //数据为空时显示的View（文字设置此时失效）
@property (nonatomic, copy) NSString *failureText; //数据为失败时显示的文字
@property (nonatomic, strong) UIView *failureView; //数据为失败时显示的View（文字设置此时失效）

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) TRequestBlock requestBlock;
@property (nonatomic, copy) TableViewSelectBlock selectBlock;
@property (nonatomic, copy) CreatTableViewCellBlock creatCellBlock;
@property (nonatomic, copy) CalculateHeightOfRow calculateHeightofRowBlock;

- (void)refreshDataHandler:(void (^)())refreshDone;
- (void)tableViewDataSourceAndDelegate:(UITableView *)tableView andWithoutLoadMore:(BOOL)withoutLoadMore;
- (void)clearData;

@end
