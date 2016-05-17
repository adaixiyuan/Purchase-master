//
//  HomePageCell.m
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "HomePageCell.h"

static const float ImageWidth = 100;
static const float ImageHeight = 80;

@implementation HomePageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        _goodsImageView.layer.borderColor = separateLineColor.CGColor;
        _goodsImageView.layer.borderWidth = HalfScale;
        [self.contentView addSubview:_goodsImageView];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
    }
    return self;
}

@end
