//
//  CustomModel.m
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "CustomModel.h"

@interface CustomModel()

@property (nonatomic, strong) NSArray *imgSizeArray;
@property (nonatomic, copy) NSString *format;

@end

@implementation CustomModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"itemId",
                                                       @"image_size.s" : @"imgSizeArray"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


- (NSNumber *)imgSizeWidth
{
    NSNumber *imgSizeWith = (NSNumber *)self.imgSizeArray[0];
    return imgSizeWith;
}

- (NSNumber *)imgSizeHeight
{
    NSNumber *imgSizeHeight = (NSNumber *)self.imgSizeArray[1];
    return imgSizeHeight;
}

- (ContentType)contentType
{
    if ([self.format isEqualToString:@"image"]) {
        return ImageContentType;
    }
    return NoImageContentType;
}

@end
