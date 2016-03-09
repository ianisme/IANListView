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
    _listView.cellIdentifier = @"cellIdentifier";
    _listView.cellClass = NSStringFromClass([IANCustomCell class]);
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
    ds.creatCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSMutableArray *dataArray){
        NSString *cellIdentifier = @"cellIdentifier";
        IANCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[indexPath.row] error:nil];
        [cell configCellWithModel:model];
       
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSIndexPath *indexPath, NSMutableArray *dataArray){
        
        if (indexPath.row < [dataArray count]) {
            CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[indexPath.row] error:nil];
            NSLog(@"测试：%f",[IANCustomCell heightWithModel:model]);
            return [IANCustomCell heightWithModel:model];

        }
        return (CGFloat)44.0;
    };
    
    ds.selectBlock = ^(NSIndexPath *indexPath, NSMutableArray *dataArray){
        
        NSLog(@"点击了第%ld行", (long)indexPath.row);
        
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
