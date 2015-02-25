//
//  NewPagedDataSource.h
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewListViewDataSource.h"

typedef void(^TRequestBlock)(NSDictionary *, void(^)(BOOL successful, id result));

@interface NewPagedDataSource : NSObject<NewListViewDataSource>
{
@private
    BOOL _hasMore;
}

@property (nonatomic, readonly) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) TRequestBlock requestBlock;

@end
