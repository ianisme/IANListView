//
//  RootViewController.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "NewListView.h"
#import "AFNetworking.h"
#import "UUtil.h"

@interface RootViewController ()
{
    NewListView *_listView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NewListView";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _listView = [[NewListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    NewPagedDataSource *ds = [[NewPagedDataSource alloc] init];
    ds.pageSize = 20;
    ds.requestBlock = ^(NSDictionary *params, void(^dataArrayDone)(BOOL, id)){
        
        NSString *str=[NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/suggest?count=%ld&page=%ld",[params[@"page_size"] integerValue],[params[@"page"] integerValue]];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"获取到的数据为：%@",dict);
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dict[@"items"]];
            
            dataArrayDone(1,tempArray);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dataArrayDone(0,error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSInteger row, NSMutableArray *dataArray){
        NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.text = ((NSDictionary *)dataArray[row])[@"content"];
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSInteger row, NSMutableArray *dataArray){

        if (row < [dataArray count]) {
            CGSize size = [UUtil textSize:((NSDictionary *)dataArray[row])[@"content"] font:[UIFont systemFontOfSize:14.0f] bounding:CGSizeMake(self.view.bounds.size.width-30, INT32_MAX)];
            return size.height+10;
        }
        return (CGFloat)44.0;
    };

    ds.selectBlock = ^(NSInteger row, NSMutableArray *dataArray){
        
        NSLog(@"点击了第%ld行", (long)row);
        
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
