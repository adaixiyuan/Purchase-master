//
//  HomePageCell.m
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "HomePageCell.h"
#import "KeyNoteModel.h"

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
        _goodsImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_goodsImageView];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont customFontOfSize:14];
        _titleLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont customFontOfSize:14];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_contentLabel];
        
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont customFontOfSize:12];
        _tagLabel.textColor = NAVBARCOLOR;
        [self.contentView addSubview:_tagLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.bottom.equalTo(_contentLabel.mas_top).with.offset(-5);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.bottom.equalTo(_tagLabel.mas_top).with.offset(-5);
        }];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.bottom.equalTo(_goodsImageView.mas_bottom).with.offset(-5);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_goodsImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)setCellContentWithDic:(NSDictionary *)dic
{
    KeyNoteModel *keyNote = [KeyNoteModel mj_objectWithKeyValues:dic];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:SAFE_STRING(keyNote.img_urls)]];
    _titleLabel.text = SAFE_STRING(keyNote.title);
    _contentLabel.text = SAFE_STRING(keyNote.content);
    _tagLabel.text = SAFE_STRING(keyNote.tag);
    
}
- (void)tapAction
{
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]) {
        [self.theDelegate imageTapAction:self];
    }
}
@end
