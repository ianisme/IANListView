//
//  IANCustomCell.m
//  IANListView
//
//  Created by ian on 16/3/1.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANCustomCell.h"
#import <Masonry/Masonry.h>

@implementation IANCustomCell
{
    UILabel *_contentLabel;
    UIImageView *_imageView;
}


#pragma mark - lift style

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
        [self creatConstraint];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
}

#pragma mark - private method

- (void)creatView
{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    
    CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width - 30;
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:12.0f];
    _contentLabel.preferredMaxLayoutWidth = preferredWidth;
    [self.contentView addSubview:_contentLabel];
}

- (void)creatConstraint
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15.0f);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).with.offset(7.0f);
        make.left.equalTo(_imageView);
        make.right.equalTo(self.contentView).with.offset(-15.0f);
    }];
    
    [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (NSString *)getImageURLStr:(NSString *)itemId
{
    NSString *firstStr = [itemId substringWithRange:NSMakeRange(0, 5)];
    NSString *result = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/small/app%@.jpg",firstStr,itemId,itemId];
    return result;
}

- (void)configCellWithModel:(CustomModel *)model
{
    if (model.contentType == ImageContentType) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self getImageURLStr:[NSString stringWithFormat:@"%zd",model.itemId.integerValue]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = image;
            });
        });
        
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(7.0f);
            make.width.equalTo(@(model.imgSizeWidth.integerValue));
            make.height.equalTo(@(model.imgSizeHeight.integerValue));
        }];
        
    } else {
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
    }
    
    _contentLabel.text = model.content;
    

}

+ (CGFloat)heightWithModel:(CustomModel *)model
{
    IANCustomCell *cell = [[IANCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:model];
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell->_contentLabel.frame;
    return frame.origin.y + frame.size.height + 7.0f;
}

@end
