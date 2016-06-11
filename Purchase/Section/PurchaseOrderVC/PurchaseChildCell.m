//
//  PurchaseChildCell.m
//  Purchase
//
//  Created by luoheng on 16/6/11.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "PurchaseChildCell.h"

static const float ImageWidth = 100;
static const float ImageHeight = 85;
static const float CountWidth = 120;
static const float CountHeight = 28;

@implementation PurchaseChildCell

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
        
        [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
            make.bottom.equalTo(self.contentView).with.offset(-5);
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
        
        _priceLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont customFontOfSize:13];
        _priceLabel.textColor = SHALLOWGRAY;
        [self.contentView addSubview:_priceLabel];
        
        _goods_noLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _goods_noLabel.backgroundColor = [UIColor clearColor];
        _goods_noLabel.font = [UIFont customFontOfSize:13];
        _goods_noLabel.textColor = SHALLOWGRAY;
        [self.contentView addSubview:_goods_noLabel];
        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.and.height.equalTo(@(25));
        }];
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(_selectBtn.mas_right).with.offset(10);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(-6);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-5);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numLabel.mas_bottom).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
        }];
        [_goods_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLabel.mas_bottom).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_goodsImageView addGestureRecognizer:tap];
    }
    return self;
}
- (void)setCellContentWithPurchaseInfo:(NSDictionary *)purchaseDic
{
    // 如果sid为0, 表示该商品为聚合商品, 不可以直接操作采购, 订货,或者缺货
    PurchaseInfoModel *purchaseModel = [PurchaseInfoModel mj_objectWithKeyValues:purchaseDic];
    self.numLimit = purchaseModel.wait_to_buy;  // 数量限制
    
    NSString *need_buyStr = NSInternationalString(@"待采购数", @"待采购数");
    NSString *price_str = NSInternationalString(@"价格", @"价格");
    NSString *goods_No = NSInternationalString(@"商品条码", @"商品条码");
    NSString *detailStr;
    NSRange infoRange = NSMakeRange(0, purchaseModel.brand_name.length);
    if (purchaseModel.brand_name == nil || purchaseModel.brand_name.length == 0) {
        detailStr = SAFE_STRING(purchaseModel.des);
    }else{
        detailStr = [NSString stringWithFormat:@"%@  %@",SAFE_STRING(purchaseModel.brand_name),SAFE_STRING(purchaseModel.des)];
    }
    NSString *numStr = [NSString stringWithFormat:@"%@：%d",need_buyStr,(int)purchaseModel.wait_to_buy];
    NSString *priceStr = [NSString stringWithFormat:@"%@：%.2f",price_str,purchaseModel.price];
    NSString *goods_NoStr;
    if (purchaseModel.goods_no.length == 0) {
        goods_NoStr = [NSString stringWithFormat:@"%@：--",goods_No];
    }else{
        goods_NoStr = [NSString stringWithFormat:@"%@：%@",goods_No,purchaseModel.goods_no];
    }
    
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
    [_priceLabel setText:priceStr];
    [_goods_noLabel setText:goods_NoStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange noRange = NSMakeRange(goods_No.length+1, goods_NoStr.length-goods_No.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:11.5];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:noRange];
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[SHALLOWBLACK CGColor] range:noRange];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length == 0) {
        textField.text = @"0";
    }
    if ([textField.text integerValue] > self.numLimit){
        [MYMBProgressHUD showMessage:NSInternationalString(@"数目不能超过待采购数~", @"数目不能超过待采购数~")];
        textField.text = [NSString stringWithFormat:@"%d",(int)self.numLimit];
    }
    if ([textField.text integerValue] > 0) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(updateCellSelectStatus:)]) {
        [self.theDelegate updateCellSelectStatus:self];
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
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]) {
        [self.theDelegate imageTapAction:self];
    }
}
- (void)numCutBtnAction:(UIButton *)btn
{
    NSInteger num = [_numText.text integerValue];
    if (num > 0) {
        num = num-1;
    }
    _numText.text = [NSString stringWithFormat:@"%d",(int)num];
    if ([_numText.text integerValue] > 0) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(updateCellSelectStatus:)]) {
        [self.theDelegate updateCellSelectStatus:self];
    }
}
- (void)numAddBtnAction:(UIButton *)btn
{
    NSInteger num = [_numText.text integerValue];
    if (num < self.numLimit) {
        num = num+1;
    }
    _numText.text = [NSString stringWithFormat:@"%d",(int)num];
    if ([_numText.text integerValue] > 0) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(updateCellSelectStatus:)]) {
        [self.theDelegate updateCellSelectStatus:self];
    }
}

@end
