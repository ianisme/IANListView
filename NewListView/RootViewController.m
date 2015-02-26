//
//  RootViewController.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "NewListView.h"
@interface RootViewController ()
{
    NewListView *_listView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NewListView";
    
    _listView = [[NewListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NewPagedDataSource *ds = [[NewPagedDataSource alloc] init];
    ds.pageSize = 2;
    ds.requestBlock = ^(NSDictionary *params, void(^dataArrayDone)(BOOL, id)){
        
        // 网络请求成功
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:@"测试1", @"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",@"测试2", @"测试3", @"测试2", @"测试3",nil];
        dataArrayDone(1,tempArray);
        
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSInteger row, NSMutableArray *dataArray){
        NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = dataArray[row];
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSInteger row, NSMutableArray *dataArray){

        if (row < [dataArray count]) {
            return (CGFloat)150;
        }
        return (CGFloat)44.0;
    };

    ds.selectBlock = ^(NSInteger row, NSMutableArray *dataArray){
        
        NSLog(@"测试一下%ld", (long)row);
        
    };
    _listView.dataSource = ds;
    
    [self.view addSubview:_listView];
    
    [_listView startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
