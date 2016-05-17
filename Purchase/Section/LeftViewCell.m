//
//  LeftViewCell.m
//  Purchase
//
//  Created by luoheng on 16/5/4.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont customFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.and.height.equalTo(@30);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_iconImageView.mas_right).with.offset(15);
            make.width.equalTo(@100);
        }];
    }
    return self;
}

@end
