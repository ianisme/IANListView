//
//  TestPageDataSource.m
//  NewListView
//
//  Created by ian on 15/2/25.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "TestPageDataSource.h"

@implementation TestPageDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataArray[row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row
{
    NSLog(@"点击了第%ld行",(long)row);
}

- (CGFloat)heightOfRow:(NSInteger)row
{
    if (row < [self.dataArray count]) {
        return 110;
    }
    return 44.0;
}

@end
