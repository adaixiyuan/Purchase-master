//
//  RecordViewCell.m
//  Purchase
//
//  Created by luoheng on 16/5/10.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "RecordViewCell.h"
#import "RecordInfoModel.h"

static const float ImageWidth = 100;
static const float ImageHeight = 80;

@implementation RecordViewCell

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
        self.leftButtons = @[[MGSwipeButton buttonWithTitle:NSInternationalString(@"删除", @"删除") backgroundColor:NAVBARCOLOR]];
        self.leftSwipeSettings.transition = MGSwipeTransitionDrag;
        
        self.rightButtons = @[[MGSwipeButton buttonWithTitle:NSInternationalString(@"更新", @"更新") backgroundColor:NAVBARCOLOR]];
        self.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.backgroundColor = [UIColor clearColor];
        [_selectButton setImage:[UIImage imageNamed:@"chooes_no"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"chooes_yes"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        _goodsImageView.userInteractionEnabled = YES;
        _goodsImageView.layer.borderColor = separateLineColor.CGColor;
        _goodsImageView.layer.borderWidth = HalfScale;
        [self.contentView addSubview:_goodsImageView];
        
        _goodsDetailsLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _goodsDetailsLabel.backgroundColor = [UIColor clearColor];
        _goodsDetailsLabel.font = [UIFont customFontOfSize:13];
        _goodsDetailsLabel.textColor = SHALLOWBLACK;
        _goodsDetailsLabel.numberOfLines = 2;
        [self.contentView addSubview:_goodsDetailsLabel];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.textColor = SHALLOWBLACK;
        _numLabel.font = [UIFont customFontOfSize:13];
        [self.contentView addSubview:_numLabel];
        
        _updateNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _updateNumLabel.backgroundColor = [UIColor clearColor];
        _updateNumLabel.textColor = SHALLOWBLACK;
        _updateNumLabel.font = [UIFont customFontOfSize:13];
        [self.contentView addSubview:_updateNumLabel];
        
        _numText = [[UITextField alloc]init];
        _numText.backgroundColor = [UIColor clearColor];
        _numText.layer.borderWidth = HalfScale;
        _numText.layer.borderColor = separateLineColor.CGColor;
        _numText.textColor = SHALLOWBLACK;
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.returnKeyType = UIReturnKeyDone;
        _numText.delegate = self;
        [self.contentView addSubview:_numText];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont customFontOfSize:13];
        _timeLabel.textColor = SHALLOWGRAY;
        [self.contentView addSubview:_timeLabel];

        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.and.height.equalTo(@0);
        }];
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_selectButton.mas_right).with.offset(0);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        [_goodsDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsDetailsLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        
        [_updateNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
            make.bottom.equalTo(_goodsImageView.mas_bottom).with.offset(0);
            make.right.equalTo(_numText.mas_left).with.offset(0);
            make.width.equalTo(@(60*SizeScaleWidth));
            make.height.equalTo(@(25*SizeScaleHeight));
        }];
        [_numText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_updateNumLabel.mas_centerY).with.offset(0);
            make.left.equalTo(_updateNumLabel.mas_right).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(25*SizeScaleHeight));
        }];

        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
            make.bottom.equalTo(_goodsImageView.mas_bottom).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(25*SizeScaleHeight));
        }];
        
        _updateNumLabel.hidden = YES;
        _numText.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_goodsImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)setCellContentConstraintsWithStatus:(BOOL)isEdit
{
    _numText.text = nil;
    self.isEdit = isEdit;
    float space = 0.0;
    if (isEdit == NO) {
        space = 0;
    }else{
        space = 10;
    }
    [self updateTheConstraintsWithSpace:space];
}
- (void)updateTheConstraintsWithSpace:(float)space
{
    [_selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(10);
        make.width.and.height.equalTo(@(2.5*space));
    }];
    [_goodsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(_selectButton.mas_right).with.offset(space);
        make.width.equalTo(@(ImageWidth*SizeScaleWidth));
        make.height.equalTo(@(ImageHeight*SizeScaleWidth));
    }];
    [_goodsDetailsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
        make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.equalTo(@(35*SizeScaleHeight));
    }];
    [_numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsDetailsLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    
    
    [_updateNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
        make.bottom.equalTo(_goodsImageView.mas_bottom).with.offset(0);
        make.right.equalTo(_numText.mas_left).with.offset(0);
        make.width.equalTo(@(60*SizeScaleWidth));
        make.height.equalTo(@(25*SizeScaleHeight));
    }];
    [_numText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_updateNumLabel.mas_centerY).with.offset(0);
        make.left.equalTo(_updateNumLabel.mas_right).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.equalTo(@(25*SizeScaleHeight));
    }];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_goodsDetailsLabel.mas_left).with.offset(0);
        make.bottom.equalTo(_goodsImageView.mas_bottom).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.height.equalTo(@(25*SizeScaleHeight));
    }];
    
    if (space > 0) {
        _timeLabel.hidden = YES;
        _updateNumLabel.hidden = NO;
        _numText.hidden = NO;
    }else{
        _timeLabel.hidden = NO;
        _updateNumLabel.hidden = YES;
        _numText.hidden = YES;
    }
}
- (void)setCellContentWithDataDic:(NSDictionary *)dic
{
    RecordInfoModel *recordModel = [RecordInfoModel mj_objectWithKeyValues:dic];
    NSString *detailStr;
    NSRange range = NSMakeRange(0, 0);
    if (recordModel.brand_name == nil || recordModel.brand_name.length == 0) {
        detailStr = SAFE_STRING(recordModel.des);
    }else{
        range = NSMakeRange(0, recordModel.brand_name.length);
        detailStr = [NSString stringWithFormat:@"%@  %@",SAFE_STRING(recordModel.brand_name),SAFE_STRING(recordModel.des)];
    }
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:SAFE_STRING(recordModel.img_url)]];
    [_goodsDetailsLabel setText:detailStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    NSString *num_Str = NSInternationalString(@"商品个数", @"商品个数");
    _numLabel.text = [NSString stringWithFormat:@"%@：%d",num_Str,(int)recordModel.quantity];
    _updateNumLabel.text = NSInternationalString(@"新个数", @"新个数");
    _timeLabel.text = SAFE_STRING(recordModel.create_dt);
}
#pragma mark - Event
- (void)selectBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(btnSelectActionWithBtnStatus:withTarget:)]) {
        [self.theDelegate btnSelectActionWithBtnStatus:btn.selected withTarget:self];
    }
}
- (void)tapAction
{
    if (self.isEdit == NO) {
        if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]) {
            [self.theDelegate imageTapAction:self];
        }
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([aString length] >= 4) {
        textField.text = [aString substringToIndex:4];
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
