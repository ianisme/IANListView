//
//  UUtil.m
//  NewListView
//
//  Created by ian on 15/2/27.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "UUtil.h"

@implementation UUtil
+ (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
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
