//
//  IANCustomCell.h
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"

@interface IANCustomCell : UITableViewCell

- (void)configCellWithModel:(CustomModel *)model;

+ (CGFloat)heightWithModel:(CustomModel *)model;

@end
