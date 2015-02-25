//
//  NewListView.h
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListViewDataSource.h"
@interface NewListView : UIView<UITableViewDataSource, UITableViewDelegate>
{
@private
    BOOL _isEmpty;
    BOOL _isFailing;
}
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) id<NewListViewDataSource> dataSource;
@property (nonatomic, copy) NSString *empryText;

- (void)startLoading;
- (void)refreshList:(BOOL)force;
- (void)reloadData;

@end
