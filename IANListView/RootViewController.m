//
//  RootViewController.m
//  IANListView
//
//  Created by ian on 15/2/25.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "IANListView.h"
#import "AFNetworking.h"
#import "IANCustomCell.h"
#import "CustomModel.h"

@interface RootViewController ()

@property (nonatomic, strong) IANListView *listView;

@end

@implementation RootViewController

#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IANListView";
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dict[@"items"]];
            
            dataArrayDone(YES,tempArray);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dataArrayDone(NO,error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSInteger row, NSMutableArray *dataArray){
        NSString *cellIdentifier = @"cellIdentifier";
        IANCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[IANCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[row] error:nil];
        cell.model = model;
       
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSInteger row, NSMutableArray *dataArray){
        
        if (row < [dataArray count]) {
            CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[row] error:nil];
        CGSize size = [self textSize:model.content font:[UIFont systemFontOfSize:12.0f] bounding:CGSizeMake(self.view.bounds.size.width - 30, INT32_MAX)];
            if (model.contentType == ImageContentType) {
                return size.height + model.imgSizeHeight.integerValue + 45;
            } else {
                return size.height + 30;
            }

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

- (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
{
    if (!(text && font) || [text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return CGRectIntegral(rect).size;
}

@end
