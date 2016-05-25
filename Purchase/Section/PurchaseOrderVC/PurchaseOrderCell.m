//
//  PurchaseOrderCell.m
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "PurchaseOrderCell.h"

static const float ImageWidth = 100;
static const float ImageHeight = 80;
static const float CountWidth = 120;
static const float CountHeight = 28;

@implementation PurchaseOrderCell

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
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"select_highlited"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        _goodsImageView.layer.borderColor = separateLineColor.CGColor;
        _goodsImageView.layer.borderWidth = HalfScale;
        _goodsImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_goodsImageView];
        
        _countView = [[UIImageView alloc]init];
        _countView.backgroundColor = [UIColor clearColor];
        _countView.userInteractionEnabled = YES;
        _countView.image = [UIImage imageNamed:@"trade_btn_num"];
        [self.contentView addSubview:_countView];
        
        _numCutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numCutBtn.backgroundColor = [UIColor clearColor];
        [_numCutBtn setImage:[UIImage imageNamed:@"btn_cut"] forState:UIControlStateNormal];
        [_numCutBtn addTarget:self action:@selector(numCutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_countView addSubview:_numCutBtn];
        _numText = [[UITextField alloc]init];
        _numText.backgroundColor = [UIColor clearColor];
        _numText.delegate = self;
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.returnKeyType = UIReturnKeyDone;
        _numText.font = [UIFont customFontOfSize:14];
        _numText.textColor = SHALLOWBLACK;
        _numText.text = @"0";
        [_countView addSubview:_numText];
        _numAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numAddBtn.backgroundColor = [UIColor clearColor];
        [_numAddBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        [_numAddBtn addTarget:self action:@selector(numAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_countView addSubview:_numAddBtn];
        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.and.height.equalTo(@0);
        }];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_selectBtn.mas_right).with.offset(5);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        
        [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.equalTo(@(CountWidth*SizeScaleWidth));
            make.height.equalTo(@(CountHeight*SizeScaleWidth));
        }];
        [_numCutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countView).with.offset(0);
            make.left.equalTo(_countView).with.offset(0);
            make.bottom.equalTo(_countView).with.offset(0);
            make.width.equalTo(@(CountWidth*SizeScaleWidth/3));
        }];
        [_numText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countView).with.offset(0);
            make.left.equalTo(_numCutBtn.mas_right).with.offset(0);
            make.bottom.equalTo(_countView).with.offset(0);
            make.right.equalTo(_numAddBtn.mas_left).with.offset(0);
        }];
        [_numAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countView).with.offset(0);
            make.right.equalTo(_countView).with.offset(0);
            make.bottom.equalTo(_countView).with.offset(0);
            make.width.equalTo(_numCutBtn.mas_width);
        }];
        
        _infoLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont customFontOfSize:14];
        _infoLabel.numberOfLines = 2;
        _infoLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_infoLabel];
        
        _numLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.font = [UIFont customFontOfSize:13];
        _numLabel.textColor = SHALLOWGRAY;
        [self.contentView addSubview:_numLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_goodsImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)setCellContentConstraintsWithEditStatus:(BOOL)isEdit
{
    _numText.text = nil;
    _isEdit = isEdit;
    if (isEdit == NO) {
        [_selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.and.height.equalTo(@0);
        }];
        [_goodsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_selectBtn.mas_right).with.offset(5);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        [_infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
    }else{
        [_selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.and.height.equalTo(@25);
        }];
        [_goodsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_selectBtn.mas_right).with.offset(10);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        [_infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
    }
}
- (void)setCellContentWithPurchaseInfo:(NSDictionary *)purchaseDic
{
    PurchaseInfoModel *purchaseModel = [PurchaseInfoModel mj_objectWithKeyValues:purchaseDic];
    NSString *detailStr;
    NSRange infoRange = NSMakeRange(0, 0);
    if (purchaseModel.brand_name == nil || purchaseModel.brand_name.length == 0) {
        detailStr = SAFE_STRING(purchaseModel.des);
    }else{
        infoRange = NSMakeRange(0, purchaseModel.brand_name.length);
        detailStr = [NSString stringWithFormat:@"%@  %@",SAFE_STRING(purchaseModel.brand_name),SAFE_STRING(purchaseModel.des)];
    }
    
    NSString *numStr = [NSString stringWithFormat:@"待采购数：%d   价格:%.2f",(int)purchaseModel.wait_to_buy,purchaseModel.price];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:SAFE_STRING(purchaseModel.img_url)]];
    [_infoLabel setText:detailStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:14];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:infoRange];
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:infoRange];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_numLabel setText:numStr];

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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length == 0) {
        textField.text = @"0";
    }
}
- (void)selectBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(updateCellSelectStatus:)]) {
        [self.theDelegate updateCellSelectStatus:self];
    }
}
- (void)tapAction
{
    if (_isEdit == NO) {
        if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]) {
            [self.theDelegate imageTapAction:self];
        }
    }
}
- (void)numCutBtnAction:(UIButton *)btn
{
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(goodsCountCut:)]) {
        [self.theDelegate goodsCountCut:self];
    }
}
- (void)numAddBtnAction:(UIButton *)btn
{
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(goodsCountAdd:)]) {
        [self.theDelegate goodsCountAdd:self];
    }
}
@end
