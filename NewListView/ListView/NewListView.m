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

- (void)refreshList:(BOOL)force
{
    if (!force) {
        
    }
    
    [_dataSource refresh:force handler:^(BOOL success, id result){

    
    
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (<#condition#>) {
//        <#statements#>
//    }
//}
//-----------------------------

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
}
@end
