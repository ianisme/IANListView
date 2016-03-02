//
//  CustomModel.h
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, ContentType) {
    ImageContentType = 0,
    NoImageContentType
};

@interface CustomModel : JSONModel

@property (nonatomic, assign) ContentType contentType;
@property (nonatomic, strong) NSNumber *itemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSNumber *imgSizeWidth;
@property (nonatomic, assign) NSNumber *imgSizeHeight;
@end
