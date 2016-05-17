//
//  GoodsInfoCell.m
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsInfoCell.h"
#import "GoodsInfoModel.h"

static const float ImageWidth = 110;
static const float ImageHeight = 90;
static const float CountWidth = 120;
static const float CountHeight = 28;

@implementation GoodsInfoCell

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
        _goodsImageView.backgroundColor = viewBgColor;
        _goodsImageView.userInteractionEnabled = YES;
        _goodsImageView.layer.borderColor = separateLineColor.CGColor;
        _goodsImageView.layer.borderWidth = HalfScale;
        [self.contentView addSubview:_goodsImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_goodsImageView addGestureRecognizer:tap];
        
        _countView = [[UIImageView alloc]init];
        _countView.backgroundColor = [UIColor clearColor];
        _countView.userInteractionEnabled = YES;
        _countView.image = [UIImage imageNamed:@"trade_btn_num"];
        [self.contentView addSubview:_countView];
        
        _numCutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numCutBtn.backgroundColor = [UIColor clearColor];
        [_numCutBtn setImage:[UIImage imageNamed:@"btn_cut"] forState:UIControlStateNormal];
        [_countView addSubview:_numCutBtn];
        _numText = [[UITextField alloc]init];
        _numText.backgroundColor = [UIColor clearColor];
        _numText.delegate = self;
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.returnKeyType = UIReturnKeyDone;
        _numText.font = [UIFont customFontOfSize:14];
        [_countView addSubview:_numText];
        _numAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numAddBtn.backgroundColor = [UIColor clearColor];
        [_numAddBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        [_countView addSubview:_numAddBtn];
        
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartButton.backgroundColor = [UIColor clearColor];
        [_cartButton setImage:[UIImage imageNamed:@"icon_cart"] forState:UIControlStateNormal];
        [self.contentView addSubview:_cartButton];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        
        [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
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
        
        [_cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_countView.mas_centerY).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.width.and.height.equalTo(_countView.mas_height);
        }];
        
        _goodsDesLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _goodsDesLabel.backgroundColor = [UIColor clearColor];
        _goodsDesLabel.font = [UIFont customFontOfSize:14];
        _goodsDesLabel.textColor = SHALLOWBLACK;
        _goodsDesLabel.numberOfLines = 2;
        [self.contentView addSubview:_goodsDesLabel];
        
        _sellLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _sellLabel.backgroundColor = [UIColor clearColor];
        _sellLabel.font = [UIFont customFontOfSize:12];
        _sellLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_sellLabel];
        
        _storeLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _storeLabel.backgroundColor = [UIColor clearColor];
        _storeLabel.font = [UIFont customFontOfSize:12];
        _storeLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_storeLabel];
        
        _waitToBuyLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _waitToBuyLabel.backgroundColor = [UIColor clearColor];
        _waitToBuyLabel.font = [UIFont customFontOfSize:12];
        _waitToBuyLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_waitToBuyLabel];
        
        _puchaseLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _puchaseLabel.backgroundColor = [UIColor clearColor];
        _puchaseLabel.font = [UIFont customFontOfSize:12];
        _puchaseLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_puchaseLabel];
        
        [_goodsDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(-5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.equalTo(@(35*SizeScaleHeight));
        }];
        [_sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsDesLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(_storeLabel.mas_left).with.offset(-10);
            make.bottom.equalTo(_waitToBuyLabel.mas_top).with.offset(-5);
            make.width.equalTo(_storeLabel.mas_width);
            make.width.equalTo(_waitToBuyLabel.mas_width);
            make.width.equalTo(_puchaseLabel.mas_width);
            make.height.equalTo(_storeLabel.mas_height);
            make.height.equalTo(_waitToBuyLabel.mas_height);
            make.height.equalTo(_puchaseLabel.mas_height);
        }];
        [_storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsDesLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_sellLabel.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.bottom.equalTo(_waitToBuyLabel.mas_top).with.offset(-5);
        }];
        [_waitToBuyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sellLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(_puchaseLabel.mas_left).with.offset(-10);
            make.bottom.equalTo(_countView.mas_top).with.offset(-5);
        }];
        [_puchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sellLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_sellLabel.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-15);
            make.bottom.equalTo(_countView.mas_top).with.offset(-5);
        }];
    }
    return self;
}
- (void)setCellContentWithGoodsDic:(NSDictionary *)infoDic
{
    GoodsInfoModel *goodsModel = [GoodsInfoModel mj_objectWithKeyValues:infoDic];
    
    NSString *detailStr;
    NSRange range = NSMakeRange(0, 0);
    if (goodsModel.brand_name == nil || goodsModel.brand_name.length == 0) {
        detailStr = SAFE_STRING(goodsModel.des);
    }else{
        range = NSMakeRange(0, goodsModel.brand_name.length);
        detailStr = [NSString stringWithFormat:@"%@  %@",SAFE_STRING(goodsModel.brand_name),SAFE_STRING(goodsModel.des)];
    }
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:SAFE_STRING(goodsModel.img_url)]];
    
    [_goodsDesLabel setText:detailStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:14];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    NSString *sellStr = [NSString stringWithFormat:@"销量：%d",(int)goodsModel.sell_qty];
    NSString *storeStr = [NSString stringWithFormat:@"库存：%d",(int)goodsModel.stock_qty];
    NSString *buyStr = [NSString stringWithFormat:@"待采购：%d",(int)goodsModel.wait_to_buy];
    NSString *purchaseStr = [NSString stringWithFormat:@"收购量：%d",(int)goodsModel.publish_qty];
    
    [_sellLabel setText:sellStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(3, sellStr.length-3);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_storeLabel setText:storeStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(3, storeStr.length-3);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_waitToBuyLabel setText:buyStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(4, buyStr.length-4);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_puchaseLabel setText:purchaseStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(4, purchaseStr.length-4);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if(self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]){
        [self.theDelegate imageTapAction:self];
    }
}

@end
