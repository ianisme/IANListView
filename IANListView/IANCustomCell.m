//
//  IANCustomCell.m
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANCustomCell.h"

@implementation IANCustomCell
{
    UILabel *_contentLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initMyView];
    }
    return self;
}

- (void)initMyView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_contentLabel];
}

- (NSString *)getImageURLStr:(NSString *)itemId
{
    NSString *firstStr = [itemId substringWithRange:NSMakeRange(0, 5)];
    NSString *result = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/small/app%@.jpg",firstStr,itemId,itemId];
    return result;
}


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

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.model.format isEqualToString:@"image"]) {
        _imageView.frame = CGRectMake(15, 15, self.model.sizeWith, self.model.sizeHeight);
        _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self getImageURLStr:self.model.itemId]]]];
    } else {
        _imageView.frame = CGRectZero;
    }
    
    CGSize size = [self textSize:self.model.content font:[UIFont systemFontOfSize:12.0f] bounding:CGSizeMake(self.bounds.size.width-30, INT32_MAX)];
    
    _contentLabel.frame = CGRectMake(15, _imageView.frame.origin.y + _imageView.frame.size.height + 15, self.frame.size.width - 30, size.height);
    
    _contentLabel.text = self.model.content;
    
    
}
@end
