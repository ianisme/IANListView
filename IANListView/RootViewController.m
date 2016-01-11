//
//  RootViewController.m
//  IANListView
//
//  Created by ian on 15/2/14.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "IANListView.h"
#import "AFNetworking.h"

@interface RootViewController ()
{
    IANListView *_listView;
}
@end

@implementation RootViewController

#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IANListView";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _listView = [[IANListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    IANPageDataSource *ds = [[IANPageDataSource alloc] init];
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
            CGSize size = [self textSize:((NSDictionary *)dataArray[row])[@"content"] font:[UIFont systemFontOfSize:14.0f] bounding:CGSizeMake(self.view.bounds.size.width-30, INT32_MAX)];
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

#pragma mark - private method

- (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
{
    if (!(text && font) || [text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
        CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return CGRectIntegral(rect).size;
    } else {
        return [text sizeWithFont:font constrainedToSize:size];
    }
    return size;
}

@end
