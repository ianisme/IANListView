//
//  CustomModel.h
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, assign) NSUInteger sizeWith;
@property (nonatomic, assign) NSUInteger sizeHeight;

@end
